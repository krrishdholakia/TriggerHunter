//
//  ViewController.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 10/5/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ARViewController: UIViewController {
    
    var trigger: Trigger?
    
    @IBOutlet var sceneView: ARSKView!
    var triggerNode: SKNode?
    
    private var 🚨overrideARTriggerWithImage🚨 = false
    
    // MARK: Presentation
    
    static func create(for trigger: Trigger?) -> ARViewController {
        let arController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AR") as! ARViewController
        arController.trigger = trigger
        return arController
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        self.overlayContentViewController = TriggerNearbyViewController.create(for: trigger)
        
        let doubleTapGestrureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDoubleTapped))
        doubleTapGestrureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGestrureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Managing overlay content view controller
    
    var overlayContentViewController: UIViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            
            overlayContentViewController?.loadView()
            guard let newOverlayView = overlayContentViewController?.view else {
                return
            }
            
            newOverlayView.backgroundColor = .clear
            
            view.addSubview(newOverlayView)
            newOverlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            newOverlayView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            newOverlayView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            newOverlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            overlayContentViewController?.viewDidLoad()
        }
    }
    
    // MARK: User Interaction and event responses
    
    @objc func viewDoubleTapped() {
        guard triggerNode == nil, let trigger = trigger else {
            return
        }
        
        // plane detection is slow on older devices,
        // so for our demo we want to be able to force the trigger to appear
        // if it's taking too long
        🚨overrideARTriggerWithImage🚨 = true
        
        let triggerImageView = UIImageView(image: trigger.image)
        triggerImageView.contentMode = .scaleAspectFill
        triggerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(triggerImageView)
        
        NSLayoutConstraint.activate([
            triggerImageView.widthAnchor.constraint(equalToConstant: 150),
            triggerImageView.heightAnchor.constraint(equalToConstant: 150),
            triggerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            triggerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 170)
        ])
        
        // continue as if the trigger appeared normally
        triggerDidBecomeVisible()
    }
    
    func triggerDidBecomeVisible() {
        guard let trigger = trigger else { return }
        overlayContentViewController = TriggerNameViewController.create(for: trigger)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let triggerInfo = TriggerInfoViewController.create(for: trigger)
            triggerInfo.delegate = self
            self.overlayContentViewController = triggerInfo
        }
    }
    
    func showQuiz(for question: Question) {
        let questionViewController = QuizQuestionViewController.create(for: question)
        questionViewController.delegate = self
        overlayContentViewController = questionViewController
    }
    
}

// MARK: ARSCNViewDelegate

extension ARViewController: ARSKViewDelegate {
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard !🚨overrideARTriggerWithImage🚨,
            anchor is ARPlaneAnchor,
            self.triggerNode == nil,
            let trigger = trigger else
        {
            return nil
        }
        
        let triggerTexture = SKTexture(image: trigger.image)
        let triggerSize = CGSize(width: 150, height: 150)
        let triggerNode = SKSpriteNode(texture: triggerTexture, size: triggerSize)
        self.triggerNode = triggerNode
        triggerDidBecomeVisible()
        
        return triggerNode
    }
    
}

// MARK: TriggerInfoViewControllerDelegate

extension ARViewController: TriggerInfoViewControllerDelegate {
    
    func didTapNextButton() {
        guard let firstQuestion = trigger?.quiz.questions.first else {
            return
        }
        
        showQuiz(for: firstQuestion)
    }
    
}

// MARK: QuizQuestionViewControllerDelegate

extension ARViewController: QuizQuestionViewControllerDelegate {
    
    func userDidCompleteQuizQuestion(_ currentQuestion: Question) {
        if let nextQuestion = trigger?.quiz.question(after: currentQuestion) {
            showQuiz(for: nextQuestion)
        } else {
            (UIApplication.shared.delegate?.window??.rootViewController = ARViewController.create(for: nil))
        }
    }
    
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

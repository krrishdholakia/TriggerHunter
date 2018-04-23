//
//  ObjectDetectionViewController.swift
//  Trigger Hunter AR
//
//  Created by Krrish Dholakia on 4/21/18.
//  Copyright © 2018 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit
import UIKit
import SceneKit
import ARKit

import Vision

class ObjectDetectionViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction

    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    var objectList: [String] = ["monitor","thermostat", "smoke alarm", "bed", "sink", "soap", "trashcan", "nurse", "mop", "flower","clock", "inhaler", "tissues"]
    var triggerMap: Dictionary<String, Trigger> = [:]
    
    var trigger: Trigger?

    static func create() -> ObjectDetectionViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "Trigger Detecting") as! ObjectDetectionViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true
        
        self.overlayContentViewController = RoomScanViewController.create()
        
        for object in objectList {
            switch object {
            case "bed":
                triggerMap[object] = Trigger.named("Dust Mite")
                break
                
            case "smoke alarm":
                triggerMap[object] = Trigger.named("Smoke")
                break
                
            case "tissues":
                triggerMap[object] = Trigger.named("Flu Virus")
                break
                
            case "flower":
                triggerMap[object] = Trigger.named("Pollen")
                break
                
            default:
                break
            }
            
        }
        
        
        // Set up Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: Inceptionv3().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        // Do any additional setup after loading the view.
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        
        DispatchQueue.main.async {
            
            // Print Classifications
            print(classifications)
            print("--")
            
            // Store the latest prediction
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.latestPrediction = objectName
            
            
            if self.objectList.contains(self.latestPrediction) {
                let trigger = self.triggerMap.removeValue(forKey: self.latestPrediction) ?? Trigger.named("Dust Mite")
                    self.overlayContentViewController = ARViewController.create(for: trigger)
            }
            if self.latestPrediction.contains("monitor") {
                self.trigger = self.triggerMap.removeValue(forKey: self.latestPrediction) ?? Trigger.named("Dust Mite")
//                self.overlayContentViewController = ARViewController.create(for: trigger)
//
//
                self.performSegue(withIdentifier: "ARIdentifier", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ARViewController {
            destination.trigger = trigger
        }
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
    
    func updateCoreML() {
        ///////////////////////////
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        ///////////////////////////
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        ///////////////////////////
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }

    // MARK: - CoreML Vision Handling
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

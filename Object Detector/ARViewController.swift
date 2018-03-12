//
//  ViewController.swift
//  TriggerHunterDev
//
//  Created by Krrish Dholakia on 3/10/18.
//  Copyright © 2018 Krrish Dholakia. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var object:String = ""
    
    var shipAdded:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        sceneView.delegate = self
        
        let scene = SCNScene(named: "ship2.scn")!
        
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    
    ////     Override to create and configure nodes for anchors added to the view's session.
    //    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    //        let node = SCNNode()
    //
    //        return node
    //
//        }
    func addTapGestureToSceneView() {
        //tapgesture setup
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.tapped(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)




        // now you can recognize EVERY tap
        
    }
    
    @objc func tapped(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            
            // this means the node has been touched
            print("tapped the ship")
            
            let alert = UIAlertController(title: "Question#1", message: "Is heavy exercise a trigger for asthma?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            print("tapped something besides the ship")
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}




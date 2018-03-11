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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScene()
    }
    
    func setupScene() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
        print("shipAdded: " + shipAdded.description)
        
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.addShipToSceneView(withGestureRecognizer:)))
                    sceneView.addGestureRecognizer(tapGestureRecognizer)




        // now you can recognize EVERY tap
        
    }

    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        if shipAdded == false {
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            
            guard let hitTestResult = hitTestResults.first else { return }
            let translation = hitTestResult.worldTransform.translation
            let x = translation.x
            let y = translation.y
            let z = translation.z
            
            guard let shipScene = SCNScene(named: "ship2.scn"),
                let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
                else { return }
            
            
            shipNode.position = SCNVector3(x,y,z)
            sceneView.scene.rootNode.addChildNode(shipNode)
            shipAdded = true
        } else {
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


    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
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

extension float4x4 {
//    var translation: float3 {
//        let translation = self.columns.3
//        return float3(translation.x, translation.y, translation.z)
//    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}


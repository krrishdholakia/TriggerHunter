//
//  ViewController.swift
//  Object Detector
//
//  Created by Sai Sandeep on 01/08/17.
//  Copyright © 2017 Sai Sandeep. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML
import ImageIO
import ARKit

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ARSCNViewDelegate {
        
    var objectList: [String] = ["monitor","thermostat", "smoke alarm", "bed", "sink", "soap", "trashcan", "nurse", "mop", "flower","clock", "inhaler", "tissues"]
    
    var object:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return }
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, error) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let firstObservation = results.first else {
                return
            }
            
            
            self.object = firstObservation.identifier
            
            
            for item in self.objectList {
                if self.object == item {
                    print("match found")
                    self.performSegue(withIdentifier: "ARSegue", sender: self)
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ARViewController {
            destination.object = self.object
        }
    }
    
}




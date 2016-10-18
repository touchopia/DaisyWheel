//
//  PhotoViewController.swift
//
//
//  Created by Phil Wright on 12/8/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var noCameraLabel: UILabel!
    
    fileprivate var captureSession: AVCaptureSession = AVCaptureSession()
    fileprivate var stillImageOutput: AVCaptureStillImageOutput?
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var capturedImage: UIImage?
    
    //MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoViewController.takePhoto))
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        guard let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            self.noCameraLabel.isHidden = false
            return
        }
        
        var error : NSError?
        var input: AVCaptureDeviceInput?
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let e as NSError {
            input = nil
            error = e
        }
        
        if error == nil && captureSession.canAddInput(input) {
            captureSession.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
                
                if let layer = AVCaptureVideoPreviewLayer(session: captureSession) {
                    layer.videoGravity = AVLayerVideoGravityResizeAspect
                    layer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewView.layer.addSublayer(layer)
                    previewLayer = layer
                }
                
                captureSession.startRunning()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let layer = previewLayer {
            layer.frame = previewView.bounds
        } else {
            print("No Layer Created -- Are we on the simulator?")
        }
    }
    
    func takePhoto() {
        guard let output = stillImageOutput else {
            print("No Output Detected")
            return
        }
        
        if let videoConnection = output.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            output.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.capturedImage = image
                    
                    self.performSegue(withIdentifier: "ShowImage", sender: self)
                }
            })
        }
    }
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if unwindSegue.identifier == "ShowImage" {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImage" {
            if let controller = segue.destination as? DetailViewController {
                controller.capturedImage = self.capturedImage
            }
        }
    }
}


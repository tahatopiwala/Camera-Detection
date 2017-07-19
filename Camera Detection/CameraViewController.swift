//
//  CameraViewController.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let avCaptureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraSetup = setUpCamera()
        if cameraSetup {
            DispatchQueue.main.async {
                //self.avCaptureSession.startRunning()
            }
        }
        
        let detectionInformationAndControlView = DetailDectionView(frame: CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: view.frame.height))
        view.addSubview(detectionInformationAndControlView)
    }
    
    func setUpCamera() -> Bool {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return false }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return false }
        
        if avCaptureSession.canAddInput(videoInput) {
            avCaptureSession.addInput(videoInput)
            avCaptureSession.sessionPreset = .hd4K3840x2160
        }
        
        if avCaptureSession.canAddOutput(videoOutput) {
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoOutputQueue"))
            avCaptureSession.addOutput(videoOutput)
        }
        
        if avCaptureSession.canAddOutput(photoOutput) {
            avCaptureSession.addOutput(photoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        previewLayer.frame = cameraView.frame
        
        cameraView.layer.addSublayer(previewLayer)
        
        return true
    }
    
    func perfromImageDetection(with pixelBuffer: CVPixelBuffer) {
        
//        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        
//        let request = VNCoreMLRequest(model: model) { (request, error) in
//
//            guard let results = request.results as? [VNClassificationObservation], let observation = results.first else { return }
//
//            guard let value = observation.identifier.components(separatedBy: ",").first else { return }
//            let confidenceValue = Double(observation.confidence).roundTo(places: 2)
//            DispatchQueue.main.async {
//                self.predictionLabel.text = "\(value.capitalized.trimmingCharacters(in: CharacterSet.whitespaces)) (\(confidenceValue))"
//            }
//        }
//
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//
//        do {
//            try handler.perform([request])
//        } catch let error {
//            print(error)
//        }
    }
}

// Video Capture Delegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    @IBAction func record(_ sender: UIButton) {
//        if avCaptureSession.isRunning {
//            turnRecordButton(to: #imageLiteral(resourceName: "record"))
//            avCaptureSession.stopRunning()
//        } else {
//            turnRecordButton(to: #imageLiteral(resourceName: "stop"))
//            avCaptureSession.startRunning()
//        }
//    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        perfromImageDetection(with: pixelBuffer)
    }
}

// Still Photo Delegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    @IBAction func takeImage(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let dataImage = photo.fileDataRepresentation() else { return }
        
        let image = UIImage(data: dataImage)
        
//        performSegue(withIdentifier: segueNameToStillImage, sender: image)
    }
}

//
//  CameraViewController.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController {
    
    var observationCount = 5
    
    var detectionInformationAndControlView: DetailDectionView!
    
    var observationTableData = [String]()
    
    let avCaptureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraSetup = setUpCamera()
        if cameraSetup {
            DispatchQueue.main.async {
                self.avCaptureSession.startRunning()
            }
        }
        
        detectionInformationAndControlView = DetailDectionView(frame: CGRect(x: 0, y: view.frame.height - 60, width: view.frame.width, height: view.frame.height))
        detectionInformationAndControlView.delegate = self
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
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let observationResults = request.results as? [VNClassificationObservation] else { return }
            
            if observationResults.count >= self.observationCount {
                let observationSubset = observationResults.slice(for: self.observationCount)
                self.observationTableData.removeAll()
                for observation in observationSubset {
                    guard let value = observation.identifier.components(separatedBy: ",").first else { return }
                    let confidenceValue = Double(observation.confidence).roundTo(places: 2)
                    self.observationTableData.append("\(value) (\(confidenceValue))")
                }
                self.detectionInformationAndControlView.updateViewData(with: self.observationTableData)
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([request])
        } catch let error {
            print(error)
        }
    }
}

// Video Capture Delegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        perfromImageDetection(with: pixelBuffer)
    }
}

// Still Photo Delegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let dataImage = photo.fileDataRepresentation() else { return }
        
        let image = UIImage(data: dataImage)
        
//        performSegue(withIdentifier: segueNameToStillImage, sender: image)
    }
}

extension CameraViewController: CameraActionDelegate {
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func toggleCameraSessionFor(value: Bool) -> Bool {
        if value {
            avCaptureSession.startRunning()
        } else {
            avCaptureSession.stopRunning()
        }
        return value
    }
}

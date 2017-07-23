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
    
    var observationCount = 1
    
    var detectionInformationAndControlView: DetailDectionView!
    var cameraLayer: AVCaptureVideoPreviewLayer!
    
    var observationTableData = [String]()
    
    let objectView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor(displayP3Red: 253/255, green: 190/255, blue: 44/255, alpha: 1).cgColor
        view.layer.cornerRadius = 3.0
        return view
    }()
    
    let avCaptureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()

    var cameraView: UIView!
    
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
        view.addSubview(objectView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if avCaptureSession.isRunning {
            avCaptureSession.stopRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
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
        
        cameraView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(cameraView)
        
        cameraLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        cameraLayer.frame = cameraView.frame
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(cameraLayer)
        
        return true
    }
    
    func perfromImageDetection(with pixelBuffer: CVPixelBuffer) {
        
        guard let coreMLRequest = getCoreMLRequest() else { return }
        guard let rectangleRequest = getrectangleDetectionRequest() else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([coreMLRequest, rectangleRequest])
        } catch let error {
            print(error)
        }
    }
    
    func getCoreMLRequest() -> VNCoreMLRequest? {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return nil }
        
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
        
        return request
    }
    
    func getrectangleDetectionRequest() -> VNDetectRectanglesRequest? {
        
        let request = VNDetectRectanglesRequest { (request, error) in
            guard let observationResults = request.results as? [VNRectangleObservation] else { return }
            
            let observationResult = observationResults.first
            
            guard let boundingBox = observationResult?.boundingBox else { return }
            
            DispatchQueue.main.async {
                self.objectView.frame = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
            }
        }
        return request
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
        
        performSegue(withIdentifier: SegueNames.toImageDetail.rawValue, sender: image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ImageDetailViewController, let stillimage = sender as? UIImage else { return }
        vc.image = stillimage
    }
}

extension CameraViewController: CameraActionDelegate {
    
    func updateObservationCount(with value: Int) {
        self.observationCount = value
    }
    
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

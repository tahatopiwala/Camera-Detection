//
//  CameraControlCenterUIView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/19/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class CameraControlCenterUIView: UIView {
    
    var cameraSession: Bool? = false
    
    var delegate: CameraActionDelegate?
    
    var captureStillImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "capture-still"), for: .normal)
        return button
    }()
    
    var videoCaptureButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "toggle-off"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func captureStillImage(_ sender: UIButton) {
        delegate?.capturePhoto()
    }
    
    @objc func toggleVideoSession(_ sender: UIButton) {
        guard let cameraSession = cameraSession else { return }
        
        if cameraSession {
            videoCaptureButton.setImage(#imageLiteral(resourceName: "toggle-off"), for: .normal)
        } else {
            videoCaptureButton.setImage(#imageLiteral(resourceName: "toggle-on"), for: .normal)
        }
        
        self.cameraSession = delegate?.toggleCameraSession(value: !cameraSession)
    }
    
    func setUpView() {
        
        captureStillImageButton.addTarget(self, action: #selector(CameraControlCenterUIView.captureStillImage(_:)), for: UIControlEvents.touchUpInside)
        videoCaptureButton.addTarget(self, action: #selector(CameraControlCenterUIView.toggleVideoSession(_:)), for: UIControlEvents.touchUpInside)
        
        addSubview(captureStillImageButton)
        addSubview(videoCaptureButton)
        
        addConstraintsWithFormat(format: "H:|-[v0(40)]", views: captureStillImageButton)
        addConstraintsWithFormat(format: "V:|-[v0(40)]", views: captureStillImageButton)
        
        addConstraintsWithFormat(format: "H:[v0(40)]-|", views: videoCaptureButton)
        addConstraintsWithFormat(format: "V:|-[v0(40)]", views: videoCaptureButton)
    }
}

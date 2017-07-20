//
//  CameraControlCenterUIView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/19/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class CameraControlCenterUIView: UIView {
    
    var delegate: CameraActionDelegate!
    
    var cameraSession: Bool = true
    
    let captureStillImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "capture-still"), for: .normal)
        return button
    }()
    
    let videoCaptureButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "toggle-off"), for: .normal)
        return button
    }()
    
    let arrowTopImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "arrow-top")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraControlCenterUIView.changeArrowImage(notification:)), name: NSNotification.Name(AppNotificationCenterName.changeArrowImage.rawValue), object: nil)
        
        setUpView()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func captureStillImage(_ sender: UIButton) {
        delegate.capturePhoto()
    }
    
    @objc func toggleVideoSession(_ sender: UIButton) {
        cameraSession = delegate.toggleCameraSessionFor(value: !cameraSession)
        
        if cameraSession {
            videoCaptureButton.setImage(#imageLiteral(resourceName: "toggle-off"), for: .normal)
        } else {
            videoCaptureButton.setImage(#imageLiteral(resourceName: "toggle-on"), for: .normal)
        }
    }
    
    func setUpView() {
        
        captureStillImageButton.addTarget(self, action: #selector(CameraControlCenterUIView.captureStillImage(_:)), for: UIControlEvents.touchUpInside)
        videoCaptureButton.addTarget(self, action: #selector(CameraControlCenterUIView.toggleVideoSession(_:)), for: UIControlEvents.touchUpInside)
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        
        
        stackView.addArrangedSubview(captureStillImageButton)
        stackView.addArrangedSubview(videoCaptureButton)
        stackView.addArrangedSubview(arrowTopImage)
        
        addSubview(stackView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: stackView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: stackView)
        
        stackView.addConstraintsWithFormat(format: "H:[v0(40)]", views: captureStillImageButton)
        stackView.addConstraintsWithFormat(format: "V:[v0(40)]", views: captureStillImageButton)
        
        stackView.addConstraintsWithFormat(format: "H:[v0(40)]", views: videoCaptureButton)
        stackView.addConstraintsWithFormat(format: "V:[v0(40)]", views: videoCaptureButton)
        
        stackView.addConstraintsWithFormat(format: "H:[v0(40)]", views: arrowTopImage)
        stackView.addConstraintsWithFormat(format: "V:[v0(40)]", views: arrowTopImage)
        
        
    }
}

extension CameraControlCenterUIView {
    
    @objc func changeArrowImage(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: UIImage] else { return }
        
        UIView.transition(with: self.arrowTopImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.arrowTopImage.image = userInfo["image"]
        }, completion: nil)
    }
}

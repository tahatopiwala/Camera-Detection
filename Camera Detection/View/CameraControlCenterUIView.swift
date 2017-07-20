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
    
    var arrowTopImage: UIImageView = {
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
        
        addSubview(captureStillImageButton)
        addSubview(arrowTopImage)
        addSubview(videoCaptureButton)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(40)]", views: captureStillImageButton)
        addConstraintsWithFormat(format: "V:[v0(40)]", views: captureStillImageButton)
        addConstraint(NSLayoutConstraint(item: captureStillImageButton, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:[v0(40)]", views: arrowTopImage)
        addConstraintsWithFormat(format: "V:[v0(40)]", views: arrowTopImage)
        addConstraint(NSLayoutConstraint(item: arrowTopImage, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: arrowTopImage, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:[v0(40)]-16-|", views: videoCaptureButton)
        addConstraintsWithFormat(format: "V:[v0(40)]", views: videoCaptureButton)
        addConstraint(NSLayoutConstraint(item: videoCaptureButton, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
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

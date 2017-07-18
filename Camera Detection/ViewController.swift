//
//  ViewController.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detectionInformationAndControlView = DetailDectionView(frame: CGRect())
        detectionInformationAndControlView.frame = CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: view.frame.height)
        view.addSubview(detectionInformationAndControlView)
    }
}

class DetailDectionView: UIView {
    
    var originalCenter: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        isUserInteractionEnabled = true
        
        originalCenter = self.center
        
        setUpGestures()
    }
    
    override var frame: CGRect {
        didSet {
            originalCenter = center
        }
    }
    
    func setUpGestures() {
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailDectionView.handleSwipeUp(sender:))))
    }
    
    @objc func handleSwipeUp(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            updateViewPosition(with: sender)
            break
        case .ended:
            updateEdgeBoundaryViewPosition(with: sender)
            break
        default: break
        }
    }
    
    func updateViewPosition(with sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: view)
        let currentCenterPositionY = view.center.y + translation.y
        if (currentCenterPositionY >= ((view.frame.height / 2) + 20) && currentCenterPositionY <= originalCenter.y) {
            view.center = CGPoint(x: view.center.x, y: currentCenterPositionY)
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    func updateEdgeBoundaryViewPosition(with sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: view)
        let currentCenterPositionY = view.center.y + translation.y
        let percentageChange = currentCenterPositionY / originalCenter.y
        
        if (percentageChange > 0.90) {
            animate(view: view, for: originalCenter)
        } else if (percentageChange < 0.60) {
            animate(view: view, for: CGPoint(x: originalCenter.x, y: (view.frame.height / 2) + 20))
        }
    }
    
    func animate(view: UIView, for center: CGPoint) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.center = center
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


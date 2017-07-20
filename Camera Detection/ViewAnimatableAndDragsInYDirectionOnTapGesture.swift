//
//  ViewAnimatableAndDragsInYDirectionOnTapGesture.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class ViewAnimatableAndDragsInYDirectionOnTapGesture: UIView {
    
    var ViewsOriginalCenter: CGPoint!
    
    let heightOffset: CGFloat = 0
    
    func ForDragAnimatableInitializeTapGesture() {
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewAnimatableAndDragsInYDirectionOnTapGesture.handleSwipeUp(sender:))))
    }
    
    @objc private func handleSwipeUp(sender: UIPanGestureRecognizer) {
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
    
    private func updateViewPosition(with sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: view)
        let currentCenterPositionY = view.center.y + translation.y
        if (currentCenterPositionY >= ((view.frame.height / 2) + heightOffset) && currentCenterPositionY <= ViewsOriginalCenter.y) {
            view.center = CGPoint(x: view.center.x, y: currentCenterPositionY)
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    private func updateEdgeBoundaryViewPosition(with sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let translation = sender.translation(in: view)
        let currentCenterPositionY = view.center.y + translation.y
        let percentageChange = currentCenterPositionY / ViewsOriginalCenter.y
        
        if (percentageChange > 0.90) {
            animate(view: view, for: ViewsOriginalCenter) {
                NotificationCenter.default.post(name: NSNotification.Name(AppNotificationCenterName.changeArrowImage.rawValue), object: nil, userInfo: ["image" : #imageLiteral(resourceName: "arrow-top")])
            }
        } else if (percentageChange < 0.60) {
            animate(view: view, for: CGPoint(x: ViewsOriginalCenter.x, y: (view.frame.height / 2) + heightOffset)) {
                NotificationCenter.default.post(name: NSNotification.Name(AppNotificationCenterName.changeArrowImage.rawValue), object: nil, userInfo: ["image" : #imageLiteral(resourceName: "arrow-down")])
            }
        }
    }
    
    private func animate(view: UIView, for center: CGPoint, callback: @escaping () -> ()) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.center = center
        }, completion: { success in
            callback()
        })
    }
}

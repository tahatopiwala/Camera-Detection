//
//  DetailDectionView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class DetailDectionView: ViewAnimatableAndDragsInYDirectionOnTapGesture {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        isUserInteractionEnabled = true
        alpha = 0.5
        
        ViewsOriginalCenter = center
        ForDragAnimatableInitializeTapGesture()
    }
    
    override var frame: CGRect {
        didSet {
            ViewsOriginalCenter = center
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

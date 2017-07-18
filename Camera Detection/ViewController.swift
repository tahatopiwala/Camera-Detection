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

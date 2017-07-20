//
//  ImageDetailViewController.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/19/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var stillImageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            DispatchQueue.main.async {
                self.stillImageView.image = self.image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     }
    
    @IBAction func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

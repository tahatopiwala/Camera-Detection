//
//  UIViewExtentions.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/19/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

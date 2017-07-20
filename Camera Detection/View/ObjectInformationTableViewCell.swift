//
//  ObjectInformationTableViewCell.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/18/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class ObjectInformationTableViewCell: UITableViewCell {
    
    var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        return view
    }()
    
    func configureCell(description: String) {
        setUpView()
        
        descriptionLabel.text = description
    }
    
    func setUpView() {
        addSubview(descriptionLabel)
        addConstraintsWithFormat(format: "H:|-[v0]", views: descriptionLabel)
        addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 1))
        
        backgroundColor = .clear
    }
}

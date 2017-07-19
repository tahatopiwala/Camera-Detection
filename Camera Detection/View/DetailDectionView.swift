//
//  DetailDectionView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

class DetailDectionView: ViewAnimatableAndDragsInYDirectionOnTapGesture {
    
    let cellIdentifier = "ObjectInformationCell"
    
    let controlCenterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        isUserInteractionEnabled = true
        alpha = 1
        
        ViewsOriginalCenter = center
        ForDragAnimatableInitializeTapGesture()
        
        setUpViews()
    }
    
    
    func setUpViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ObjectInformationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        addSubview(controlCenterView)
        addSubview(tableView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: controlCenterView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0(80)]-8-[v1]-8-|", views: controlCenterView, tableView)
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

extension DetailDectionView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ObjectInformationTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}

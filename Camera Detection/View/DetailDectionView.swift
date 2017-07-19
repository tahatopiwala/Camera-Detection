//
//  DetailDectionView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

protocol CameraActionDelegate {
    func capturePhoto()
    func toggleCameraSession(value: Bool) -> Bool?
}

class DetailDectionView: ViewAnimatableAndDragsInYDirectionOnTapGesture {
    
    var delegate: CameraActionDelegate?
    
    var tableData = [String]()
    
    let cellIdentifier = "ObjectInformationCell"
    
    let controlCenterView: CameraControlCenterUIView = {
        let view = CameraControlCenterUIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.allowsSelection = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = true
        alpha = 1
        
        ViewsOriginalCenter = center
        ForDragAnimatableInitializeTapGesture()
        
        setUpViews()
    }
    
    
    func setUpViews() {
        
        controlCenterView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ObjectInformationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        addSubview(controlCenterView)
        addSubview(tableView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: controlCenterView)
        addConstraintsWithFormat(format: "H:|[v0]-100-|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0(80)][v1]|", views: controlCenterView, tableView)
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
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ObjectInformationTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(description: tableData[indexPath.row])
        
        return cell
    }
}

extension DetailDectionView {
    func updateViewData(with data: Any?) {
        guard let data = data as? [String] else { return }
        tableData = data
        tableView.reloadData()
    }
}

extension DetailDectionView: CameraActionDelegate {
    
    func toggleCameraSession(value: Bool) -> Bool? {
        return delegate?.toggleCameraSession(value: value)
    }
    
    func capturePhoto() {
        delegate?.capturePhoto()
    }
}

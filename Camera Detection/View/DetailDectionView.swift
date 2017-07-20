//
//  DetailDectionView.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/17/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import UIKit

@objc protocol CameraActionDelegate {
    func capturePhoto()
    func toggleCameraSessionFor(value: Bool) -> Bool
    @objc optional func updateObservationCount(with value: Int)
}

class DetailDectionView: ViewAnimatableAndDragsInYDirectionOnTapGesture {
    
    var delegate: CameraActionDelegate?
    
    var tableData = [String]()
    
    let cellIdentifier = "ObjectInformationCell"
    
    let controlCenterView: CameraControlCenterUIView = {
        let view = CameraControlCenterUIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.allowsSelection = false
        return view
    }()
    
    let stepperView: UIStepper = {
        let view = UIStepper()
        view.maximumValue = 40
        view.minimumValue = 1
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
        addSubview(stepperView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: controlCenterView)
        addConstraintsWithFormat(format: "H:|[v0]-\(frame.width * 0.25)-|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0(60)][v1]-[v2]-|", views: controlCenterView, tableView, stepperView)
        
        addConstraint(NSLayoutConstraint(item: stepperView, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        stepperView.addTarget(self, action: #selector(DetailDectionView.updateDataCount(_:)), for: .touchUpInside)
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
    
    @objc func updateDataCount(_ sender: UIStepper) {
        delegate?.updateObservationCount!(with: Int(sender.value))
    }
    
    func updateViewData(with data: Any?) {
        guard let data = data as? [String] else { return }
        tableData = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension DetailDectionView: CameraActionDelegate {
    
    func toggleCameraSessionFor(value: Bool) -> Bool {
        return (delegate?.toggleCameraSessionFor(value: value))!
    }
    
    func capturePhoto() {
        delegate?.capturePhoto()
    }
}

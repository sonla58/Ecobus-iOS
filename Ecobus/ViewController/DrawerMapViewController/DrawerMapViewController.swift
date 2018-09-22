//
//  DrawerMapViewController.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/21/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import Pulley
import IBAnimatable
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import RxGesture
import GoogleMaps

class DrawerMapViewController: UIViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var tfSearch: AnimatableTextField!
    @IBOutlet weak var widthTextFieldSearch: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sgFilter: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Declare
    
    var disposeBag = DisposeBag()
    var dataSource: BehaviorRelay<[Vehicle]> = BehaviorRelay<[Vehicle]>.init(value: AppModel.share.allVehicle.value)
    var statusFilter = Vehicle.Status.none
    var textFilter = ""
    
    // MARK: - Define
    
    let cellID = "VehicleTableViewCell"
    
    // MARK: - Setup
    
    func setupView() {
        
        tfSearch.leftView?.rx.tapGesture().when(UIGestureRecognizerState.recognized)
            .bind(onNext: { [weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tfSearch.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        tfSearch.rx.controlEvent(UIControlEvents.editingDidEnd).bind { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if (self?.textFilter ?? "").isEmpty {
                UIView.animate(withDuration: 0.2, animations: {
                    strongSelf.widthTextFieldSearch.constant = 30
                    strongSelf.btnTitle.alpha = 1
                    strongSelf.view.layoutIfNeeded()
                })
            }
        }.disposed(by: disposeBag)
        
        tfSearch.rx.controlEvent(UIControlEvents.editingDidBegin).bind { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pulleyViewController?.setDrawerPosition(position: PulleyPosition.open, animated: true)
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.widthTextFieldSearch.constant = UIScreen.main.bounds.size.width - 32
                strongSelf.btnTitle.alpha = 0
                strongSelf.view.layoutIfNeeded()
            })
        }.disposed(by: disposeBag)
        
        tfSearch.rx.text.bind { [weak self] text in
            self?.textFilter = (text ?? "").trimmingCharacters(in: [" ", "."])
            AppModel.share.allVehicle.accept(AppModel.share.allVehicle.value)
        }.disposed(by: disposeBag)
        
        sgFilter.rx.controlEvent(UIControlEvents.valueChanged).bind { [weak self] in
            guard let strongSelf = self else {
                return
            }
            switch strongSelf.sgFilter.selectedSegmentIndex {
            case 0:
                strongSelf.statusFilter = .none
                break
            case 1:
                strongSelf.statusFilter = .run
                break
            case 2:
                strongSelf.statusFilter = .stop
                break
            case 3:
                strongSelf.statusFilter = .loseSignal
                break
            default:
                break
            }
            AppModel.share.allVehicle.accept(AppModel.share.allVehicle.value)
        }.disposed(by: disposeBag)
        
    }
    
    func setupTableView() {
        tableView.rowHeight = 64
        tableView.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        AppModel.share.allVehicle.bind { [weak self] (vehicles) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.isHidden = vehicles.count == 0
            let filterVehicle = vehicles.filter({ (e) -> Bool in
                let textFilterRes = strongSelf.textFilter.isEmpty ? true : e.name.contains(strongSelf.textFilter)
                if strongSelf.statusFilter != .none {
                    return (strongSelf.statusFilter == e.statusCode) && textFilterRes
                }
                return textFilterRes
            })
            strongSelf.dataSource.accept(filterVehicle)
        }.disposed(by: self.disposeBag)
        dataSource.bind(to: tableView.rx.items(cellIdentifier: cellID)) { [weak self] (index, data, cell) in
            if let cell = cell as? VehicleTableViewCell {
                cell.setDataForCell(data: data)
            }
        }.disposed(by: self.disposeBag)
        tableView.rx.itemSelected.bind { [weak self] indexPath in
            self?.trackingVehicle(vehicle: self!.dataSource.value[indexPath.row])
            }.disposed(by: self.disposeBag)
    }
    
    // MARK: - ViewController's life
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        setupView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    func loadData() {
        TrackingVehicleManager.shared.delegate = self
        TrackingVehicleManager.shared.startTrackingVehicle(mode: TrackingVehicleManager.TrackingStatus.high)
    }
    
    func trackingVehicle(vehicle: Vehicle) {
        if let mapVC = self.pulleyViewController?.primaryContentViewController as? MapScreenViewController {
            if let cdn = vehicle.coordinate {
                mapVC.mapView.animate(to: GMSCameraPosition.init(target: cdn, zoom: 15, bearing: 0, viewingAngle: 0))
                if let marker = mapVC.vehicleMarker.filter({ (maker) -> Bool in
                    return maker.title == vehicle.name
                }).first {
                    mapVC.mapView.selectedMarker = marker
                }
            }
        }
    }

}

extension DrawerMapViewController: PulleyDrawerViewControllerDelegate {
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.partiallyRevealed, .open, .closed, .collapsed]
    }
    
}

extension DrawerMapViewController: TrackingVehicleDelegate {
    
    func didStartTrackingVehicle() {
        self.activityIndicator.startAnimating()
    }
    
    func didReceiveErrorWhenTrackingData() {
        self.activityIndicator.stopAnimating()
    }
    
    func didReceiveNewVehicleData() {
        self.activityIndicator.stopAnimating()
    }
}

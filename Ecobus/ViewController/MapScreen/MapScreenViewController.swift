//
//  MapScreenViewController.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/17/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift
import GoogleMaps
import Kingfisher
import Pulley

class MapScreenViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Declare
    
    let locationManager = CLLocationManager.init()
    var disposeBag = DisposeBag()
    var vehicleMarker: [GMSMarker] = []
    
    // MARK: - Define
    
    // MARK: - Setup
    
    func setMyLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func setupmapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: 145, right: 0)
        mapView.delegate = self
    }
    
    func setupContainerView() {
        self.pulleyViewController?.displayMode = .bottomDrawer
    }
    
    func setObserve() {
        AppModel.share.allVehicle.bind { [weak self] (vehicles) in
            guard let strongSelf = self else {
                return
            }
            for vehicle in vehicles {
                if let existMaker = strongSelf.vehicleMarker.first(where: { (maker) -> Bool in
                    return (maker.userData as? Vehicle)?.id == vehicle.id
                }) {
                    if let coordinate = vehicle.coordinate {
                        let heading = vehicle.headingDegree == nil ? nil : CLLocationDegrees.init(vehicle.headingDegree!)
                        existMaker.updateMarker(coordinates: coordinate, degrees: heading, duration: 7)
                        existMaker.userData = vehicle
                        existMaker.userData = vehicle
                        existMaker.title = vehicle.name
                        existMaker.snippet = vehicle.address
                        (existMaker.iconView as? UIImageView)?.kf.setImage(with: vehicle.zeroImageUrl)
                    }
                } else {
                    if let coordinate = vehicle.coordinate {
                        let maker = GMSMarker.init(position: coordinate)
                        maker.userData = vehicle
                        maker.title = vehicle.name
                        maker.snippet = vehicle.address
                        maker.isFlat = true
                        maker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
                        maker.layer.rotation = CLLocationDegrees.init(vehicle.headingDegree ?? 0)
                        strongSelf.setUpMarkersIconWithZoomLevel(zoom: strongSelf.mapView.camera.zoom)
                        maker.map = strongSelf.mapView
                        strongSelf.vehicleMarker.append(maker)
                    }
                }
            }
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: - ViewController's life
    override func viewDidLoad() {
        super.viewDidLoad()

        setMyLocation()
        setupmapView()
        loadData()
        setObserve()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupContainerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateToMyLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateToMyLocation() {
        if let myLocation = locationManager.location?.coordinate {
            mapView.animate(to: GMSCameraPosition.init(target: myLocation, zoom: 14, bearing: CLLocationDirection.init(), viewingAngle: 0))
        }
    }
    
    func loadData() {
        //
    }

}

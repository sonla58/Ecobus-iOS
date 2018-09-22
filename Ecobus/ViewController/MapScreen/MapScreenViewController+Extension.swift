//
//  MapScreenViewController+Extension.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/17/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SnapKit
import Pulley

extension MapScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            animateToMyLocation()
            break
        case .authorizedWhenInUse:
            animateToMyLocation()
            break
        case .denied:
            if !CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.openURL(url)
                }
            } else {
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    // If general location settings are enabled then open location settings for the app
                    UIApplication.shared.openURL(url)
                }
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            if !CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.openURL(url)
                }
            } else {
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    // If general location settings are enabled then open location settings for the app
                    UIApplication.shared.openURL(url)
                }
            }
            break
        }
    }
}

extension MapScreenViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        setUpMarkersIconWithZoomLevel(zoom: position.zoom)
    }
    
    // map
    
    func setUpMarkersIconWithZoomLevel(zoom: Float) {
        if zoom < 10 {
            self.vehicleMarker.forEach { (maker) in
                maker.iconView = nil
                maker.icon = UIImage.init(named: "dot")
            }
        } else if zoom >= 10 && zoom < 15 {
            self.vehicleMarker.forEach { (maker) in
                if let existIconView = maker.iconView as? UIImageView {
                    let ratio = Float(34-17)/5.0
                    existIconView.frame = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(17.0 + Float(zoom - 10)*ratio), height: CGFloat(17.0 + Float(zoom - 10)*ratio))
                    return
                }
                if let vehicle = maker.userData as? Vehicle {
                    let ratio = Float(34-17)/5.0
                    let imageView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: CGFloat(17 + Float(zoom - 10)*ratio), height: CGFloat(17 + Float(zoom - 10)*ratio)))
                    imageView.contentMode = .scaleAspectFit
                    imageView.kf.setImage(with: vehicle.zeroImageUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, cache, url) in
                        maker.iconView = imageView
                    })
                    maker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
                }
            }
        } else {
            
        }
    }
    
}

extension MapScreenViewController: PulleyPrimaryContentControllerDelegate {
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition != .open && distance < 268 {
            mapView.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: distance + 4, right: 0)
        }
    }
    
}

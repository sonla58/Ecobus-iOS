//
//  GMSMarker+Extension.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/19/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import GoogleMaps

extension GMSMarker {
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees?, duration: Double) {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        if let degrees = degrees {
            self.rotation = degrees
        }
        CATransaction.commit()
        
        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        self.position = coordinates
        CATransaction.setCompletionBlock {
            self.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.infoWindowAnchor = CGPoint.init(x: 0.5, y: 0)
        }
        
        // Center Map View
//        let camera = GMSCameraUpdate.setTarget(coordinates)
//        mapView.animateWithCameraUpdate(camera)
        
        CATransaction.commit()
    }
}

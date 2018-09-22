//
//  Vehicle.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftDate

class Vehicle {
    
    init(id: Int, rawValue: String) {
        self.id = id
        self.rawValue = rawValue
        
        var componentValues = rawValue.split(separator: ",")
        
        var lastIndexAddress = 8
        var address = componentValues[8]
        
        for i in 9..<componentValues.count {
            let element = componentValues[i]
            address += element
            if element.contains("\"") {
                lastIndexAddress = i
                break
            }
        }
        
        let arr1 = componentValues[0..<8]
        let arr2 = componentValues[(lastIndexAddress + 1)...]
        let newComponents = (arr1 + [address] + arr2).map { (e) -> String in
            return e.trimmingCharacters(in: [" ", "\n", "\"", "\\", "\r"])
        }
        
        if let lat = CLLocationDegrees.init(newComponents[9]), let lng = CLLocationDegrees.init(newComponents[10]) {
            self.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
        }
        self.name = newComponents[0]
        self.lastUpdated = Date.init(newComponents[3], format: "dd/MM/yyyy hh:mm:ss", region: Region.current)
        self.address = newComponents[8]
        self.status = newComponents[5]
        self.speed = newComponents[6]
        self.imageUrl = URL.init(string: "http://ecopark.vnetgps.com/" + newComponents[16])
        self.zeroImageUrl = URL.init(string: "http://ecopark.vnetgps.com/" + newComponents[16].findNumberAndReplace(replaceBy: "0"))
        self.headingDegree = Int(newComponents[20])
        let rawStatus = Int(newComponents[11]) ?? -1
        switch rawStatus {
        case 0:
            self.statusCode = .run
            break
        case 1:
            self.statusCode = .stop
            break
        case 3:
            self.statusCode = .loseSignal
            break
        default:
            break
        }
    }
    
    var id: Int = 0
    var rawValue: String = ""
    
    var lastUpdated: Date?
    var address: String = ""
    var status: String = ""
    var coordinate: CLLocationCoordinate2D?
    var imageUrl: URL?
    var zeroImageUrl: URL?
    var headingDegree: Int?
    var name: String = ""
    var speed: String = ""
    var statusCode: Status = Status.none
    
    enum Status: Int {
        case run = 0
        case stop = 1
        case loseSignal = 3
        case none = -1
    }
    
}

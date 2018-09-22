//
//  AppConstant.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit

struct AppConstant {
    
    static var developMode = true
    
    enum Segue: String {
        case listVehicleToTracking = "listVehicleToTracking"
        case listToWeb = "listToWeb"
    }
    
    enum StoryboardID {
        
    }
    
    enum ApiKey: String {
        case googleMap = "AIzaSyDmWwqAILP322o1wSKykoKQeQsNKil4474"
    }

}

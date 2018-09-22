//
//  AppSetting.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import Foundation
import GoogleMaps
import IQKeyboardManagerSwift

struct AppSetting {
    
    static let shared = AppSetting()
    
    func setGoogleMap() {
        GMSServices.provideAPIKey(AppConstant.ApiKey.googleMap.rawValue)
    }
    
    func setKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
}

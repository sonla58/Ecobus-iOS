//
//  AppStorage.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/17/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit

class AppStorage {
    
    static let shared = AppStorage()
    
    var pref = UserDefaults.standard
    
    enum KeyStorage: String {
        case token = "@Token"
    }
    
    // Token
    
    func setToken(token: String) {
        pref.set(token, forKey: KeyStorage.token.rawValue)
        pref.synchronize()
    }
    
    func getToken() -> String? {
        return pref.string(forKey: KeyStorage.token.rawValue)
    }
    
    func removeToken() {
        pref.removeObject(forKey: KeyStorage.token.rawValue)
    }
    
}

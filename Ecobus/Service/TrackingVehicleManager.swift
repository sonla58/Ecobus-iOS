//
//  TrackingVehicleManager.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import Foundation

@objc protocol TrackingVehicleDelegate {
    @objc optional func didStartTrackingVehicle()
    @objc optional func didStopTrackingVehicle()
    @objc optional func didReceiveNewVehicleData()
    @objc optional func didReceiveErrorWhenTrackingData()
}

class TrackingVehicleManager {
    
    static let shared = TrackingVehicleManager()
    
    enum TrackingStatus: Int {
        case high = 5
        case low = 30
        case none = 0
    }
    
    var delegate: TrackingVehicleDelegate?
    var status = TrackingStatus.none
    var timer = Timer()
    
    func startTrackingVehicle(mode: TrackingStatus) {
        
        if mode == self.status {
            return
        }
        
        delegate?.didStartTrackingVehicle?()
        
        switch mode {
        case .none:
            stopTrackingVehicle()
            break
        default:
            status = .high
            RequestManager.shared.getLogin { [weak self] (success, token) in
                if success, let token = token {
                    RequestManager.shared.postLogin(token: token, complete: { [weak self] (success, isLogout) in
                        if self == nil {
                            return
                        }
                        if success {
                            self!.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self!.status.rawValue), target: self!, selector: #selector(self!.tracking), userInfo: nil, repeats: true)
                        } else if isLogout {
                            AppStorage.shared.removeToken()
                            TrackingVehicleManager.shared.startTrackingVehicle(mode: mode)
                        } else {
                            self?.delegate?.didReceiveErrorWhenTrackingData?()
                        }
                    })
                } else {
                    self?.delegate?.didReceiveErrorWhenTrackingData?()
                }
            }
            break
        }
        
    }
    
    @objc func tracking() {
        if let token = AppStorage.shared.getToken() {
            RequestManager.shared.tracking(token: token, complete: { [weak self] success in
                if success {
                    self?.delegate?.didReceiveNewVehicleData?()
                } else {
                    self?.delegate?.didReceiveErrorWhenTrackingData?()
                }
            })
        }
    }
    
    func stopTrackingVehicle() {
        timer.invalidate()
        timer = Timer()
        status = TrackingStatus.none
        delegate?.didStopTrackingVehicle?()
    }
    
}

//
//  AppModel.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AppModel {
    
    static let share = AppModel()
    
    var allVehicle: BehaviorRelay<[Vehicle]> = BehaviorRelay<[Vehicle]>.init(value: [])
    
}

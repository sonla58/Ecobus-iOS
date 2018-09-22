//
//  TrackingVehicleViewController.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/21/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackingVehicleViewController: UIViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - Declare
    
    var disposeBag = DisposeBag()
    
    // MARK: - Define
    
    // MARK: - Setup
    
    func setObserve() {
        btnClose.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - ViewController's life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setObserve()
    }

}

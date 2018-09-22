//
//  ListScreenViewController.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/19/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit

class ListScreenViewController: UIViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var btnGD1: UIButton!
    @IBOutlet weak var btnGD2: UIButton!
    
    // MARK: - Declare
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - ViewController's life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func btnGD1Taped(_ sender: Any) {
        self.performSegue(withIdentifier: AppConstant.Segue.listToWeb.rawValue, sender: 0)
    }
    
    @IBAction func btnGD2Taped(_ sender: Any) {
        self.performSegue(withIdentifier: AppConstant.Segue.listToWeb.rawValue, sender: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstant.Segue.listToWeb.rawValue {
            if let tag = sender as? Int, let vc = segue.destination as? WebScreenViewController {
                if tag == 0 {
                    vc.typeData = .pdf1
                } else if tag == 1 {
                    vc.typeData = .pdf2
                }
            }
        }
    }
}

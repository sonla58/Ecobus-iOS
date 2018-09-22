//
//  WebScreenViewController.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/21/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit

class WebScreenViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    enum TypeData {
        case none
        case pdf1
        case pdf2
        case url(String)
    }
    
    var typeData: TypeData = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch typeData {
        case .pdf1:
            do {
                if let pdfURL = Bundle.main.url(forResource: "ECOBUSGIAIDOAN1", withExtension: "pdf") {
                    let data = try Data.init(contentsOf: pdfURL)
                    let baseUrl = pdfURL.deletingLastPathComponent()
                    webView.load(data, mimeType: "application/pdf", textEncodingName: "", baseURL: baseUrl)
                }
            } catch {
                
            }
            break
        case .pdf2:
            do {
                if let pdfURL = Bundle.main.url(forResource: "ECOBUSGIAIDOAN2", withExtension: "pdf") {
                    let data = try Data.init(contentsOf: pdfURL)
                    let baseUrl = pdfURL.deletingLastPathComponent()
                    webView.load(data, mimeType: "application/pdf", textEncodingName: "", baseURL: baseUrl)
                }
            } catch {
                
            }
            break
        default:
            break
        }
    }
    
    func loadWeb() {
//        webView.load
    }

}

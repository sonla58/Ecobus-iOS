//
//  RequestManager.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/17/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import SwiftyXMLParser

class RequestManager {
    
    static let shared = RequestManager()
    
    enum RequestURL: String {
        case login = "http://ecopark.vnetgps.com/index.php?m=login"
        case data = "http://ecopark.vnetgps.com/index.php?mi=&m=maps&click=&tr=0"
        
        var url: URL? {
            get {
                return URL.init(string: self.rawValue)
            }
        }
    }
    
}

extension RequestManager {
    
    func getLogin(complete:@escaping ((_ success: Bool, _ token: String?)->Void)) {
        
        print("====> Start login")
        
        if let storageToken = AppStorage.shared.getToken() {
            print("❤️ Token found in Storage")
            complete(true, storageToken)
            return
        }
        
        print("👹 Token not found in storage, need get new one")
        let header: HTTPHeaders = [
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-US,en;q=0.9",
            "Cache-Control": "no-cache"
        ]
        
        if let url = RequestURL.login.url {
            let req = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: header)
            req.responseJSON { (data) in
                if let strCookie = data.response?.allHeaderFields["Set-Cookie"] as? String {
                    let token = strCookie.components(separatedBy: ";")[0]
                    AppStorage.shared.setToken(token: token)
                    print("❤️ get and save new token success")
                    complete(true, token)
                } else {
                    complete(false, nil)
                }
            }
        }
    }
    
    func postLogin(token: String, complete:@escaping (_ success: Bool, _ isLogout: Bool) -> Void) {
        let header: HTTPHeaders = [
            "Origin": "http://ecopark.vnetgps.com",
            "Content-type": "application/x-www-form-urlencoded",
            "User-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Referer": "http://ecopark.vnetgps.com/",
            "Accept-encoding": "gzip, deflate",
            "Accept-language": "en-US,en;q=0.9",
            "Cookie": token,
            "Cache-control": "no-cache"
        ]
        
        let params: Parameters = [
            "hide_method": "login",
            "ref_cat": "",
            "ref_id": "",
            "ref_url": "default",
            "txtUserName": "ecopark",
            "txtUserPassword": "ecopark2014"
        ]
        
        if let url = RequestURL.login.url {
            let req = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.httpBody, headers: header)
            
            req.responseString { (response) in
                do {
                    let result = try response.result.unwrap()
                    let doc: Document = try SwiftSoup.parse(result)
                    if let attr = try doc.getElementsByTag("a").first()?.attr("href") {
                        if attr.contains("logout") {
                            complete(false, true)
                            return
                        } else {
                            complete(true, false)
                            return
                        }
                    }
                    complete(false, false)
                } catch {
                    print(error)
                    complete(false, false)
                }
            }
        }
    }
    
    func tracking(token: String, complete: @escaping ((_ success: Bool)->Void)) {
        let header: HTTPHeaders = [
            "Origin": "http://ecopark.vnetgps.com",
            // "x-devtools-emulate-network-conditions-client-id": "16E95CC3897C5C03A3D7FF9A008B3E04",
            "Method": "POST http://ecopark.vnetgps.com/index.php?mi=&m=maps&click=&tr=0 HTTP/1.1",
            "User-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",
            "Content-type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Referer": "http://ecopark.vnetgps.com/index.php?mi=&m=maps&click=&tr=0",
            "Accept-encoding": "gzip, deflate",
            "Accept-language": "en-US,en;q=0.9",
            "Cookie": token + "; cookie_auto=0; cookie_remember=0",
            "Cache-control": "no-cache"
        ]
        
        let currentTime = Date.init().timeIntervalSince1970
        let dataStr = "xajax=ajxGetDeviceList&xajaxr=" + "\(currentTime)" + "&xajaxargs[]=%3Cxjxobj%3E%3Ce%3E%3Ck%3ERunning%3C%2Fk%3E%3Cv%3E1%3C%2Fv%3E%3C%2Fe%3E%3Ce%3E%3Ck%3EStop%3C%2Fk%3E%3Cv%3E1%3C%2Fv%3E%3C%2Fe%3E%3Ce%3E%3Ck%3ELostGPS%3C%2Fk%3E%3Cv%3E1%3C%2Fv%3E%3C%2Fe%3E%3Ce%3E%3Ck%3ELostGPRS%3C%2Fk%3E%3Cv%3E1%3C%2Fv%3E%3C%2Fe%3E%3Ce%3E%3Ck%3ESendingLog%3C%2Fk%3E%3Cv%3E1%3C%2Fv%3E%3C%2Fe%3E%3Ce%3E%3Ck%3EhidHWgrid%3C%2Fk%3E%3Cv%3E135%3C%2Fv%3E%3C%2Fe%3E%3C%2Fxjxobj%3E&xajaxargs[]=devicename&xajaxargs[]=asc"
        if let url = RequestURL.data.url {
            let req = Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: dataStr, headers: header)
            req.responseData { (dataResponse) in
                do {
                    let data = try dataResponse.result.unwrap()
                    let xml = XML.parse(data)
                    var vehicles: [Vehicle] = []
                    xml["xjx"]["cmd"].forEach({ (element) in
                        let unescapeElement = (element.text ?? "").unescaped
                        let range = unescapeElement.range(of: "_global.devTracking.arrDevice[")
                        if let clearRange = range {
                            if clearRange.lowerBound.encodedOffset == 0 {
                                if let firstIndex = unescapeElement.index(of: "["), let secondIndex = unescapeElement.index(of: "]") {
                                    let id = unescapeElement[unescapeElement.index(after: firstIndex)..<secondIndex]
                                    if let start = unescapeElement.index(of: "("),
                                        let end = unescapeElement.rangeOfCharacter(from: [")"], options: String.CompareOptions.backwards, range: nil)?.lowerBound {
                                        let rawValue = unescapeElement[unescapeElement.index(after: start)..<end]
                                        vehicles.append(Vehicle.init(id: Int(id) ?? 0, rawValue: String(rawValue)))
                                    }
                                }
                            }
                        }
                    })
                    if vehicles.count > 0 {
                        AppModel.share.allVehicle.accept(vehicles)
                        complete(true)
                        return
                    } else {
                        complete(false)
                    }
                } catch {
                    print(error)
                    complete(false)
                }
            }
        }
    }
    
}

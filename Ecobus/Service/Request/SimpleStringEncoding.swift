//
//  SimpleStringEncoding.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/17/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

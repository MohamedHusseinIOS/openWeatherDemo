//
//  DataResponse+Extension.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import Alamofire

extension DataResponse {
    
    func interceptResuest(_ url: String, _ params: Parameters?){
    
        print("================(\(url))============== \n")
        print("parameters =======> \(params ?? [:]) \n")
        print("Header =====> \(request?.allHTTPHeaderFields ?? [:]) \n")
        print(response?.url?.absoluteURL ?? "")
        print("statusCode =====> \(response?.statusCode ?? 00000) \n")
        print("result ======> ", (try? result.get()) ?? "")
    }
}

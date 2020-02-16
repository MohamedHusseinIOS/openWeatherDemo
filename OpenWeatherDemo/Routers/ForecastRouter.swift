//
//  ForecastRouter.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum ForecastRouter: URLRequestBuilder {
    
    case city(_ city: String)
    case fiveDayes(_ city: String)
    
    var cityName: String {
        switch self {
        case .city(let city):
            return city
        case .fiveDayes(let city):
            return city
        }
    }
    
    var path: String{
        switch self {
        case .city(_):
            return ServerPaths.CurrentWeatherData.rawValue
        case .fiveDayes(_):
            return ServerPaths.CallFiveDaysData.rawValue
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type":"application/json"]
    }
    
    var parameters: Parameters? {
        return ["q": cityName,
                "appid": "9eaccd7d404f7b648ccc4b4e37dc6a0d"]
    }
    
    var method: HTTPMethod {
        return .get
    }
        
    func request<T: BaseModel>(_ model: T.Type) -> Observable<Any?> {
        let observalbe = Observable<Any?>.create { (observer) -> Disposable in
            AF.request(self).responseJSON { (response) in
                response.interceptResuest(self.requestURL.absoluteString, self.parameters)
                let resEnum = ResponseHandler.instance.handleResponse(response, model: model)
                observer.onNext(resEnum)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        return observalbe
    }
    
}

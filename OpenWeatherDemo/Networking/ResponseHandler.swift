//
//  BaseRouter.swift
//  MenuApp
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseEnum {
    case failure(_ error: ApiError?, _ data: Any?)
    case success(_ value: Any?)
}

enum ApiError: Int {
    case BadRequest = 400
    case DataValidationFailed = 422
    case ServerError = 500
    case ClientSideError = 0
    
    var message: String{
        switch self {
        case .BadRequest:
            return "Bad request"
        case .ServerError:
            return "Internal Server Error"
        case .ClientSideError:
            return "ClientSide Error"
        case .DataValidationFailed:
            return "Data Validation Failed"
        }
    }
}

class ResponseHandler {
    
    static let instance = ResponseHandler()
    
    typealias responseCallback = ((ResponseEnum) -> Void)
    
    private init() {}
    
    func handleResponse<T: BaseModel>(_ response: AFDataResponse<Any>, model: T.Type) -> ResponseEnum {
        guard let code = response.response?.statusCode else {
            return .failure(ApiError.ClientSideError, nil)
        }
        if code < 400, let res = response.value as? Parameters {
            return handleResponseData(response: .success(res), model: model)
        } else if let res = response.value {
            return errorHandling(res, code: code)
        } else {
            return .failure(ApiError.ClientSideError, nil)
        }
    }
    
    func getDataFormDB<T: Codable>(key: String, model: T.Type) -> ResponseEnum {
        do{
            let model = try StorageManager.shared.fetchData(for: key) as T
            return .success(model)
        } catch _ {
            return .failure(nil, ErrorModel(message: "seems like not connected to the internet"))
        }
    }
    
    private func errorHandling(_ res: Any, code: Int) -> ResponseEnum {
        let error = ApiError(rawValue: code)
        let errorModel = ErrorModel.decodeJSON(res, To: ErrorModel.self, format: .convertFromSnakeCase)
        return .failure(error, errorModel)
    }
    
    private func handleResponseData<T: BaseModel>( response: ResponseEnum, model: T.Type) -> ResponseEnum {
        switch response {
        case .success(let value):
            guard let value = value else {
                return .failure(ApiError.ClientSideError, nil)
            }
            let responseData = model.decodeJSON(value, To: model, format: .convertFromSnakeCase)
            return .success(responseData)
        case .failure(let error, let data):
            return .failure(error, data)
        }
    }
}



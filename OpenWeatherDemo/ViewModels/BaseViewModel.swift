//
//  BaseViewModel.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {

    var bag = DisposeBag()
    
    init() {}
    
    func handelError(data: Any?, failer: PublishSubject<[ErrorModel]>){
        if let err = data as? ErrorModel{
            failer.onNext([err])
        }else if let errorArr = data as? [ErrorModel]{
            failer.onNext(errorArr)
        }else if let error = data as? Error {
            let error = ErrorModel(message: error.localizedDescription)
            failer.onNext([error])
        }
    }
}

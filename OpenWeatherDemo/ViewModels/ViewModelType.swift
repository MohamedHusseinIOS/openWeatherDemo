//
//  ViewModelType.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
       
    var input: Input { get }
    var output: Output { get }
}

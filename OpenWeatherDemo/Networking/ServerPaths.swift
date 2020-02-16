//
//  ServerPaths.swift
//  MenuApp
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation

enum ServerPaths: String {
    case CurrentWeatherData = "weather"
    case CallFiveDaysData = "forecast"
    
    func cityName(_ cityName: String) -> String {
        return self.rawValue + "=\(cityName)"
    }
}

//
//  DayForecast.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation

// MARK: - DayForecast
struct DayForecastResponse: BaseModel {
    let city: City?
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [DayForecast]?
}

// MARK: - DayForecast
struct DayForecast: BaseModel {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let sys: Sys?
    let dtTxt: String?
}

//MARK: - City
struct City: BaseModel {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}


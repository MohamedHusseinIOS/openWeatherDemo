//
//  CityForecast.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation

// MARK: - CityForecast
struct CityForecast: BaseModel {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: BaseModel {
    let all: Int?
}

// MARK: - Coord
struct Coord: BaseModel {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: BaseModel {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
}

// MARK: - Sys
struct Sys: BaseModel {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: BaseModel {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: BaseModel {
    let speed, deg: Double
}

//
//  SearchViewModel.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/16/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModel: BaseViewModel, ViewModelType {
    
    struct Input{
        let cities: AnyObserver<[CityForecast]>
    }
    
    struct Output{
        let cityForecast: Observable<CityForecast>
        let dayesForecast: Observable<[DayForecast]>
        let cities: Observable<[CityForecast]>
    }
    
    var input: SearchViewModel.Input
    var output: SearchViewModel.Output
    
    private let cityForecastSubj = PublishSubject<CityForecast>()
    private let dayesForecastSubj = PublishSubject<[DayForecast]>()
    private let citiesSubj = PublishSubject<[CityForecast]>()
    private let faliure = PublishSubject<[ErrorModel]>()
    
    private var cities = Array<CityForecast>()
    
    override init() {
        input = Input(cities: citiesSubj.asObserver())
        output = Output(cityForecast: cityForecastSubj.asObservable(),
                        dayesForecast: dayesForecastSubj.asObservable(),
                        cities: citiesSubj.asObservable())
    }
    
}

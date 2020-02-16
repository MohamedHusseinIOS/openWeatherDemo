//
//  MainViewModel.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel: BaseViewModel, ViewModelType {
    
    struct Input{
        //Code
        let cities: AnyObserver<[CityForecast]>
    }
    
    struct Output{
        let cityForecast: Observable<CityForecast>
        let dayesForecast: Observable<[DayForecast]>
        let cities: Observable<[CityForecast]>
    }
    
    var input: MainViewModel.Input
    var output: MainViewModel.Output
    
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
    
    func searchForCity(cityName: String) {
        MHProgress.sharedMHP.show()
        ForecastRouter.city(cityName).request(CityForecast.self).subscribe { [unowned self] (event) in
            MHProgress.sharedMHP.hide()
            switch event{
            case .next(let resEnum):
                self.getCityDayesForecast(cityName: cityName)
                self.pushCityForecastData(resEnum: resEnum as? ResponseEnum, isSearch: true)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: bag)
    }
    
    func getCityForecast(cityName: String) {
        MHProgress.sharedMHP.show()
        ForecastRouter.city(cityName).request(CityForecast.self).subscribe { [unowned self] (event) in
            MHProgress.sharedMHP.hide()
            switch event{
            case .next(let resEnum):
                self.getCityDayesForecast(cityName: cityName)
                self.pushCityForecastData(resEnum: resEnum as? ResponseEnum, isSearch: false)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: bag)
    }
    
    func getCityDayesForecast(cityName: String) {
        MHProgress.sharedMHP.show()
        ForecastRouter.fiveDayes(cityName).request(DayForecastResponse.self).subscribe { [unowned self] (event) in
            MHProgress.sharedMHP.hide()
            switch event{
            case .next(let resEnum):
                self.pushCityDayesForecastData(resEnum: resEnum as? ResponseEnum)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: bag)
    }
    
    private func pushCityForecastData(resEnum: ResponseEnum?, isSearch: Bool) {
        switch resEnum! {
        case .failure(_, let data):
            self.handelError(data: data, failer: self.faliure)
        case .success(let value):
            guard let cityForecast = value as? CityForecast else { return }
            citiesSubj.onNext([cityForecast])
            if cities.isEmpty && isSearch == false {
                addCity(city: cityForecast)
            }
        }
    }
    
    private func pushCityDayesForecastData(resEnum: ResponseEnum?) {
        switch resEnum! {
        case .failure(_, let data):
            self.handelError(data: data, failer: self.faliure)
        case .success(let value):
            guard let dayForecastRes = value as? DayForecastResponse, let dayesForecast = dayForecastRes.list else { return }
            var lastDay: DayForecast? = dayesForecast.first
            var filteredDayes = dayesForecast.filter { (day) -> Bool in
                if getDayName(day: day) != getDayName(day: lastDay!) {
                    lastDay = day
                    return true
                } else {
                    return false
                }
            }
            filteredDayes.insert(dayesForecast.first!, at: 0)
            dayesForecastSubj.onNext(filteredDayes)
        }
    }
    
    func getDayName(day: DayForecast) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let timeInterval = Double(day.dt!)
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
    
    func citiesCount() -> Int {
        return cities.count
    }
    
    func addCity(city: CityForecast) {
        cities.append(city)
        citiesSubj.onNext(cities)
    }
    
    func isCityAdded(city: CityForecast) -> Bool {
        return cities.contains { (cityForecast) -> Bool in
            return cityForecast.id == city.id
        }
    }
    
    func removeCity(city: CityForecast) {
        guard let index = cities.firstIndex(where: {$0.id == city.id}) else { return }
        cities.remove(at: index)
        citiesSubj.onNext(cities)
    }
}

//
//  DayCell.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNameLbl: UILabel!
    @IBOutlet weak var dayDateLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    
    static let id = "DayCell"
    
    
    func bindOn(day: DayForecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let timeInterval = Double(day.dt!)
        let date = Date(timeIntervalSince1970: timeInterval)
        let strDay = dateFormatter.string(from: date)
        dayNameLbl.text = strDay
        dateFormatter.dateFormat = "dd/MM"
        dayDateLbl.text = dateFormatter.string(from: date)
        minTempLbl.text = "\((day.main?.tempMin?.description) ?? "error")°F"
        maxTempLbl.text = "\((day.main?.tempMax?.description) ?? "error")°F"
    }
}

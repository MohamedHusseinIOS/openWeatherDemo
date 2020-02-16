//
//  CityCell.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CityCellBtnTitle: String {
    case add = "Add"
    case delete = "Delete"
}

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var addAndDeleteBtn: UIButton!
    @IBOutlet weak var fiveDayesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    
    static let id = "CityCell"
    
    var addOrDeleteCity: (() -> Void) = { return }
    var dayes = PublishSubject<[DayForecast]>()
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let dayForecastNib = UINib(nibName: DayCell.id, bundle: Bundle.main)
        fiveDayesCollectionView.register(dayForecastNib, forCellWithReuseIdentifier: DayCell.id)
        addAndDeleteBtn.addTarget(self, action: #selector(addAndDeleteAction(_:)), for: .touchUpInside)
        setFlowlayout()
        collectionViewSetup()
    }
    
    func setFlowlayout() {
        let flow = UICollectionViewFlowLayout()
        //let width = ((UIScreen.main.bounds.width) / 4.2)
        
        let cellCount = 3
        let cellMerginSize = 10
        let mergin = cellMerginSize * 2
        
        let width = ((self.frame.width - 70) - CGFloat(mergin) * CGFloat(cellCount) - CGFloat(mergin)) / CGFloat(cellCount)
        
        flow.scrollDirection = .vertical
        flow.itemSize = CGSize(width: width, height: (fiveDayesCollectionView.frame.height - 10))
        flow.minimumInteritemSpacing = 10
        flow.minimumLineSpacing = 10
        fiveDayesCollectionView.collectionViewLayout = flow
    }
    
    func collectionViewSetup() {
        dayes.bind(to: fiveDayesCollectionView.rx.items) { (collectionView, item, element) in
            let index = IndexPath(item: item, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.id, for: index) as? DayCell else { return DayCell() }
            cell.bindOn(day: element)
            self.dayes.onCompleted()
            return cell
        }.disposed(by: bag)
    }

    func bindOn(city: CityForecast, btnTitle: CityCellBtnTitle) {
        cityNameLbl.text = city.name
        minTempLbl.text = "\((city.main?.tempMin?.description) ?? "error")°F"
        maxTempLbl.text = "\((city.main?.tempMax?.description) ?? "error")°F"
        addAndDeleteBtn.setTitle(btnTitle.rawValue, for: .normal)
        
        switch btnTitle {
        case .add:
            addAndDeleteBtn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        case .delete:
            addAndDeleteBtn.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
    }
    
    func CanDelete(_ can: Bool){
        if addAndDeleteBtn.titleLabel?.text == CityCellBtnTitle.delete.rawValue {
            addAndDeleteBtn.isHidden = !can
        }
    }
    
    @objc func addAndDeleteAction(_ sender: UIButton) {
        addOrDeleteCity()
    }
    
}

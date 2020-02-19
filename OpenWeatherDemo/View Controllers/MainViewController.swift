//
//  ViewController.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import UIKit
import RxCocoa

class MainViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var citiesTableView: UITableView!
    
    let viewModel = MainViewModel()
    var extendedCellsIndex = Array<IndexPath>()
    var dayes = Array<DayForecast>()
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCityForecast(cityName: "egypt")
    }
    
    override func configureData() {
        viewModel.output.dayesForecast.subscribe { (event) in
            guard let dayes = event.element else { return }
            self.dayes = dayes
        }.disposed(by: viewModel.bag)
    }
    
    override func configureUI() {
        registerCell()
        setupTableView()
        didSelecteRow()
        setupSearchBar()
    }
    
    func registerCell() {
        let cityCellNib = UINib(nibName: CityCell.id, bundle: Bundle.main)
        citiesTableView.register(cityCellNib, forCellReuseIdentifier: CityCell.id)
    }
    
    func setupTableView() {
        citiesTableView.delegate = nil
        citiesTableView.dataSource = nil
        citiesTableView.rowHeight = citiesTableView.frame.height / 3
        viewModel.output
            .cities
            .bind(to: citiesTableView.rx.items){ [weak self] tableView, row, element in
                guard let self = self else { return CityCell() }
                let indexPath = IndexPath(row: row, section: 0)
                if self.searchActive {
                    return self.makeSearchCellForTV(tableView, indexPath: indexPath, element: element)
                } else {
                    return self.makeCellForTV(tableView, indexPath: indexPath, element: element)
                }
            }.disposed(by: viewModel.bag)
    }
    
    func didSelecteRow(){
        citiesTableView.rx
            .itemSelected
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                guard let indexPath = event.element else { return }
                if self.extendedCellsIndex.contains(indexPath) {
                    self.collapseCell(indexPath: indexPath)
                } else {
                    self.extendCell(indexPath: indexPath)
                }
            }.disposed(by: viewModel.bag)
    }
    
    func setupSearchBar(){
        searchBar.rx
            .searchButtonClicked
            .subscribe { [unowned self] (_) in
                guard let text = self.searchBar.text else { return }
                self.searchActive = true
                self.viewModel.searchForCity(cityName: text)
                self.view.endEditing(true)
            }.disposed(by: viewModel.bag)
    }
    
    func makeSearchCellForTV(_ tableview: UITableView, indexPath: IndexPath, element: CityForecast) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: CityCell.id , for: indexPath) as? CityCell else { return CityCell() }
        cell.bindOn(city: element, btnTitle: .add)
        
        cell.CanDelete(true)
        cell.addOrDeleteCity = { [unowned self] in
            self.viewModel.addCity(city: element)
            self.searchActive = false
        }
        if extendedCellsIndex.contains(indexPath) {
            cell.collectionViewHeightConst.constant = 142.5
        } else {
            cell.collectionViewHeightConst.constant = 0
        }
        viewModel.output.dayesForecast.bind(to: cell.dayes.asObserver()).disposed(by: viewModel.bag)
        return cell
    }
    
    func makeCellForTV(_ tableview: UITableView, indexPath: IndexPath, element: CityForecast) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: CityCell.id , for: indexPath) as? CityCell else { return CityCell() }
        cell.bindOn(city: element, btnTitle: .delete)
        if viewModel.citiesCount() == 1 {
            cell.CanDelete(false)
        } else {
            cell.CanDelete(true)
        }
        cell.addOrDeleteCity = { [unowned self] in
            self.viewModel.removeCity(city: element)
        }
        if extendedCellsIndex.contains(indexPath) {
            cell.collectionViewHeightConst.constant = 142.5
        } else {
            cell.collectionViewHeightConst.constant = 0
        }
        viewModel.output.dayesForecast.bind(to: cell.dayes.asObserver()).disposed(by: viewModel.bag)
        return cell
    }

    func extendCell(indexPath: IndexPath){
        guard let cell = self.citiesTableView.cellForRow(at: indexPath) as? CityCell else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            cell.collectionViewHeightConst.constant = 142.5
            cell.layoutIfNeeded()
        }, completion: nil)
        extendedCellsIndex.append(indexPath)
    }
    
    func collapseCell(indexPath: IndexPath){
        guard let cell = self.citiesTableView.cellForRow(at: indexPath) as? CityCell else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            cell.collectionViewHeightConst.constant = 0
            cell.layoutIfNeeded()
        }, completion: nil)
        guard let indexOfIndexPath = extendedCellsIndex.firstIndex(of: indexPath) else { return }
        extendedCellsIndex.remove(at: indexOfIndexPath)
    }
    
}

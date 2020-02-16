//
//  SearchViewController.swift
//  OpenWeatherDemo
//
//  Created by mohamed hussein on 2/16/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    let viewModel = SearchViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func configureUI() {
        
    }
    
    override func configureData() {
        
    }
    
    func setupTableView() {
        searchTableView.delegate = nil
        searchTableView.dataSource = nil
        
        viewModel.output
            .cities
            .bind(to: searchTableView.rx.items){ [weak self] tableView, row, element in
                guard let self = self else { return CityCell() }
                let indexPath = IndexPath(row: row, section: 0)
                return self.makeCellForTV(tableView, indexPath: indexPath, element: element)
            }.disposed(by: viewModel.bag)
    }
    
    func didSelecteRow(){
        searchTableView.rx
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
    
    func makeCellForTV(_ tableview: UITableView, indexPath: IndexPath, element: CityForecast) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: CityCell.id , for: indexPath) as? CityCell else { return CityCell() }
        cell.bindOn(city: element, btnTitle: .delete)
        if viewModel.citiesCount() == 1 {
            cell.CanDelete(false)
        } else {
            cell.CanDelete(true)
        }
        cell.deleteCity = { [unowned self] in
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
        guard let cell = self.searchTableView.cellForRow(at: indexPath) as? CityCell else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            cell.collectionViewHeightConst.constant = 142.5
            cell.layoutIfNeeded()
        }, completion: nil)
        extendedCellsIndex.append(indexPath)
    }
    
    func collapseCell(indexPath: IndexPath){
        guard let cell = self.searchTableView.cellForRow(at: indexPath) as? CityCell else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            cell.collectionViewHeightConst.constant = 0
            cell.layoutIfNeeded()
        }, completion: nil)
        guard let indexOfIndexPath = extendedCellsIndex.firstIndex(of: indexPath) else { return }
        extendedCellsIndex.remove(at: indexOfIndexPath)
    }

}

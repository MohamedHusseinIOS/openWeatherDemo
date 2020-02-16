//
//  mainNavoigator.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import UIKit

//MARK:- storyboards
enum storyboards: String {
    case main = "Main"
    
    var instanse: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
}

class MainNavigator{
    
    private var navigationController: UINavigationController!
    let presentNVC = UINavigationController()
    var currentVC: Destination?
    var lastVC: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension MainNavigator: Navigator{
    //MARK:- Destination
    enum Destination {
        
        //Main Storyboard
        case MainViewController

    }
    
    func navigate(To destination: Destination) {
        guard let vc = makeViewController(for: destination) else{ return }
        currentVC = destination
        lastVC = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func present(_ destination: Destination, completion: (() -> Void)?) {
        guard let vc = makeViewController(for: destination) else { return }
        presentNVC.viewControllers.append(vc)
        navigationController.viewControllers.last?.present(vc, animated: true, completion: completion)
    }
    
    func popViewController(to destination: Destination?){
        currentVC = destination
        navigationController.popViewController(animated: true)
        lastVC = navigationController.viewControllers.last
    }
    
    func makeViewController(for destination: Destination)-> UIViewController? {
        switch destination {
        //MARK:- home
        case .MainViewController:
            return mainViewControllers(by: destination)
        }
    }
    
    
    
    private func mainViewControllers(by destination: Destination) -> UIViewController? {
        switch destination {
        case .MainViewController:
            let vc = MainViewController.InstantiateFormStoryBoard(storyboards.main.instanse, vc: MainViewController())
            return vc
        }
    }
    
}

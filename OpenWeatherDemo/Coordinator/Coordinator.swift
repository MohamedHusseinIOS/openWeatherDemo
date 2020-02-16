//
//  Coordinator.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    static let shared = Coordinator()
    
    private var nvc: UINavigationController!
    private var childNVC: UINavigationController!
    
    var window: UIWindow?
    
    var mainNavigator: MainNavigator!
    
    var parentViewController: BaseViewController?
    
    private init(nvc: UINavigationController = UINavigationController()) {
        self.nvc = nvc
        self.mainNavigator = MainNavigator(navigationController: self.nvc)
    }
    
    func startApp( window: UIWindow?) {
        mainNavigator.navigate(To: .MainViewController)
        nvc.setNavigationBarHidden(false, animated: false)
        nvc.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nvc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        nvc.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        self.window = window
    }
}

//
//  BaseViewController.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/15/20.
//  Copyright © 2020 mohamed hussien. All rights reserved.
//

import UIKit

//protocol BindingConfiguration {
//    func configureData()
//    func configureUI()
//}

class BaseViewController: UIViewController, Instantiator {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUI()
        // Do any additional setup after loading the view.
    }

    func configureData(){}
    
    func configureUI(){}
    
}

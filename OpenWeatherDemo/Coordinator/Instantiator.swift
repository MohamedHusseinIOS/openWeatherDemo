//
//  instantiator.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import UIKit

protocol Instantiator {
    static func InstantiateFormStoryBoard<T: UIViewController>(_ storyboard: UIStoryboard, vc: T) -> T?
}

extension Instantiator where Self: UIViewController{
    static func InstantiateFormStoryBoard<T: UIViewController>(_ storyboard: UIStoryboard, vc: T) -> T?{
        let strArr = String(describing: vc.self).split(separator: "<")[0].split(separator: ".")[1].split(separator: ":")
        let identifier = strArr.first?.description ?? ""
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else{
            return nil
        }
        return viewController
    }
}

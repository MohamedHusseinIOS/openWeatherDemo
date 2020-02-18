//
//  UIViewController+Extension.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(title: String, message: String?, completion: (()->Void)?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        
        alert.addAction(action)
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

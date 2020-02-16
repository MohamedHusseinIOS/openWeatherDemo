//
//  Navigator.swift
//  pagination-demo
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import UIKit


protocol Navigator {
    associatedtype Destination
    func navigate(To destination: Destination)
    func present(_ destination: Destination, completion: (()->Void)?)
}

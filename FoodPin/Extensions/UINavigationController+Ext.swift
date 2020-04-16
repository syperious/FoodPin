//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/15/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

extension UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

}

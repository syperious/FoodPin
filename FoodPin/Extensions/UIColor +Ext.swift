//
//  UIColor +Ext.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/15/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}

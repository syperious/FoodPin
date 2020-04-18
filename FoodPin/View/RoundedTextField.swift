//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/18/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);

    //text indentation. returns the drawing rectangle for the text field’s text.
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    //text indentation. returns the drawing rectangle for the text field’s placeholder text.
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    //text indentation. returns the rectangle in which editable text can be displayed.
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //round corner
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}

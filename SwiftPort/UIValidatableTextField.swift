//
//  UIValidableLabel.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/15/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class UIValidatableTextField: UITextField, Validatable {

    @IBInspectable var invalidMessage: String = "Please enter a valid value"
    var validatee: String? { return text }
    var validator: (String) -> Bool = {_ in return true}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

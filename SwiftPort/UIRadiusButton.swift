//
//  UIRadiusButton.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/15/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class UIRadiusButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = CONSTANT.UI.LOGIN_BUTTON_CORNER_RADIUS
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = CONSTANT.UI.LOGIN_BUTTON_CORNER_RADIUS
    }

}

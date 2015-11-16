//
//  TabBarViewController.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/13/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //UITabBar.appearance().selectionIndicatorImage = UIImage.imageFromColorAndSize(UIColor.whiteColor(), size: CGSizeMake(200, tabBar.frame.size.height))
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(red: 22/256.0, green: 24/256.0, blue: 45/256.0, alpha: 1)
    }


}

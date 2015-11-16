//
//  EntryViewController.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/13/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    // MARK: Hide the navigation bar for the entry view
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
}

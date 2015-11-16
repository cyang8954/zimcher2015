//
//  ForgetPasswordViewController.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/15/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController, InputAlertViewContainer{

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInput: UIValidatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupValidatables()
    }
    
    func setupValidatables()
    {
        emailInput.validator = IsValid.email
    }
    
    
    @IBAction func donePressed() {
        guard validate([emailInput]) else { return }
    }
}

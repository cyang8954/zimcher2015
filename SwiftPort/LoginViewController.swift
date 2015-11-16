//
//  LoginViewController.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/14/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, InputAlertViewContainer{

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailInput: UIValidatableTextField!
    @IBOutlet weak var passwordInput: UIValidatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //dansGame WutFace
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        setupValidatables()
    }
    
    func setupValidatables()
    {
        emailInput.validator = IsValid.email
        passwordInput.validator = IsValid.password
    }

    @IBAction func donePressed() {
        let inp:[Validatable] = [emailInput, passwordInput]
        
        guard validate(inp) else { return }
        
        //Networking.userLoginWithUserJSON(payload: <#T##Any?#>, completionHandler: <#T##responseHandler?##responseHandler?##(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void#>)
    }
    
}

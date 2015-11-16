//
//  SignUpViewController.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/14/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import UIKit

class SignUpViewController: ViewControllerWithKBLayoutGuide, InputAlertViewContainer{
    //@IBOutlet weak var termsToBottom: NSLayoutConstraint!
    @IBOutlet weak var termsView: UIStackView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameInput: UIValidatableTextField!
    @IBOutlet weak var emailInput: UIValidatableTextField!
    @IBOutlet weak var passwordInput: UIValidatableTextField!
    
    
    struct LOCAL_CONSTANT {
        static let TERMS_TO_BOTTOM: CGFloat = 15
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillChange:", name: UIKeyboardWillChangeFrameNotification , object: view.window)
        
        navigationItem.leftBarButtonItem?.title = ""
        kbLayoutGuide.topAnchor.constraintEqualToAnchor(termsView.bottomAnchor, constant: LOCAL_CONSTANT.TERMS_TO_BOTTOM).active = true
        setupValidatables()
    }
    
    func setupValidatables()
    {
        nameInput.validator = IsValid.userName
        emailInput.validator = IsValid.email
        passwordInput.validator = IsValid.password
    }
    
    
    @IBAction func donePressed() {
        
        let inp: [Validatable] = [nameInput, emailInput, passwordInput]
        
        guard validate(inp) else { return }
        Networking.userRegisterWithUserJSON(payload: ["userName": nameInput.text!, "email":emailInput.text!, "password":passwordInput.text!]) { data, response, error in
            
        }
        //stub
    }
}

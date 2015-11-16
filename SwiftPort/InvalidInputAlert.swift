//
//  InvalidInputAlert.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/15/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation
import UIKit

protocol InputAlertViewContainer: class {
    var topLayoutGuide: UILayoutSupport { get }
    var view: UIView! {get}
}

extension InputAlertViewContainer{
    func showInvalidInputAlert(alertString: String)
    {
        let v = UIInvalidInputAlertView.sharedView
        
        if !view.subviews.contains(v) {
            let topLayout = NSLayoutConstraint(item: topLayoutGuide, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1, constant: 0)
            let heading = NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: v, attribute: .Leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: v, attribute: .Trailing, multiplier: 1, constant: 0)
            
            view.addSubview(v)
            view.addConstraints([topLayout, heading, trailing])
        }
        
        
        v.show(alertString)
    }
    
    func validate(input: [Validatable])-> Bool
    {
        if let errorMsg = input.filter({ i in !IsValid.hasValidInput(i.validatee, validator: i.validator) }).first?.invalidMessage {
            showInvalidInputAlert(errorMsg)
            return false
        }
        return true
    }
}




class UIInvalidInputAlertView: UIView {
    
    @IBOutlet weak var alertTextLabel: UILabel!
    
    static let sharedView = NSBundle.mainBundle().loadNibNamed("InvalidInputAlertView", owner: nil, options: nil).first as! UIInvalidInputAlertView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
    }
    
    
    func show(alertString: String)
    {
        alertTextLabel.text = alertString
        UIView.animateWithDuration(0.5, delay: 0, options: [.BeginFromCurrentState], animations: {[weak self] in self?.alpha = 0.9 })
            { [weak self] _ in
                UIView.animateWithDuration(0.5, delay: 2, options: [.BeginFromCurrentState], animations: {
                    self?.alpha = 0
                    }) {   _ in /*self?.removeFromSuperview()*/ }
            }
    }
}
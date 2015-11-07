//
//  StringValidation.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/28/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

struct IsValid {
    private static func validationCreator(filterString: String) -> (String) -> Bool
    {
        let predicate = NSPredicate(format: "SELF MATCHES %@", filterString)
        return { string in
            predicate.evaluateWithObject(string)
        }
    }

    static let email = IsValid.validationCreator(CONSTANT.VALIDATION.EMAIL_FILTER)
    static let userName = IsValid.validationCreator(CONSTANT.VALIDATION.USER_NAME_ALLOWED_CHARS)
    
}
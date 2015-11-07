//
//  Networking.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/28/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

public struct Networking {
    public typealias CompletionHandler = (data: NSData?, response: NSURLResponse?, error: NSError?)->Void
    
    public typealias JSONDictionary = NSDictionary
    
    /*
    enum DataTypes: NetworkingDataType {
        case JSON(AnyObject)
        
        func toNSData() -> NSData? {
            switch self {
            case .JSON(let json): return try? NSJSONSerialization.dataWithJSONObject(json, options: [])
            }
        }
        
        var HTMLContentType: String {
            switch self {
            case .JSON: return "application/json"
            //default: return "Unknown"
            }
        }
        
    }*/
}

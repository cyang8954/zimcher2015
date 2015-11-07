//
//  NetworkingDataType.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/30/15.
//  Copyright © 2015 Kappa. All rights reserved.
//
import Foundation

/*
protocol NetworkingDataType {
    func toNSData() -> NSData?
    var HTMLContentType: String {get}
    var contentLength: Int {get} //default
    var defaultHTTPHeaders: [String: String] {get} //default
    
}

extension NetworkingDataType {
    var contentLength: Int {return self.toNSData()?.length ?? 0}
    var defaultHTTPHeaders: [String: String] {
        return ["Content-Length": String(contentLength), "Content-Type": HTMLContentType]
    }
}

//NetworkingDataTypes Enum 
extension Networking.JSONDictionary: NetworkingDataType {
    func toNSData() -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self, options: [])
    }
    
    var HTMLContentType: String { return "application/json" }
}
*/

public enum NetworkingDataType {
    case JSON(AnyObject)
    //case MultipartFormData([AnyObject])
    
    func toNSData() -> NSData?
    {
        switch self {
        case .JSON(let raw): return try? NSJSONSerialization.dataWithJSONObject(raw, options: [])
        //default: return self
        }
    }
    
    var contentLength: Int {
        return self.toNSData()?.length ?? 0
        //stub
    }
    
    var HTMLContentType: String {
        return "application/json"
    }
    
    
    var defaultHTTPHeaders: [String: String] {
        return ["Content-Length": String(contentLength), "Content-Type": HTMLContentType]
    }
}

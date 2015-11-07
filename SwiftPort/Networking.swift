//
//  Networking.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/28/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

struct Networking {
    typealias CompletionHandler = (data: NSData?, response: NSURLResponse?, error: NSError?)->Void
    
    static let CRLF = "\r\n"
}


enum NetworkingDataType {
    case JSON(AnyObject)
    case MultipartFormData(Multipart)

    func toNSData() -> NSData?
    {
        switch self {
        case .JSON(let raw): return try? NSJSONSerialization.dataWithJSONObject(raw, options: [])
        case .MultipartFormData(let multipart): return multipart.data
        }
    }
    
    var contentLength: UInt64 {
        switch self {
        case .MultipartFormData(let mp): return mp.contentLength
        default: return UInt64(self.toNSData()?.length ?? 0)
        }
    }
    
    var HTMLContentType: String {
        switch self {
        case .JSON: return "application/json"
        case .MultipartFormData(let mp): return mp.headers["content-type"]!
        }
    }
    
    
    var defaultHTTPHeaders: [String: String] {
        switch self {
        case.JSON: return ["Content-Length": String(contentLength), "Content-Type": "application/json"]
        case.MultipartFormData(let mpf): return mpf.headers
        }
    }
    
}
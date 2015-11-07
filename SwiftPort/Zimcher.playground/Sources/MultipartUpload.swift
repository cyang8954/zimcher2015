//
//  MultipartUpload.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/3/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

extension Networking {
    
    static let CRLF = "\r\n"
    
    static func headersToString(headers: [String: String]) -> String
    {
        var headerString = ""
        for (k, v) in headers {
            headerString += "\(k): \(v)\(Networking.CRLF)"
        }
        headerString += Networking.CRLF
        
        return headerString
    }   
}

// MARK: Input data
public protocol MultipartFormInputDataType
{
    var size: UInt64 {get}
}

protocol MIMETypedData
{
    var MIMEType: String {get}
}

protocol FileTypeData: MIMETypedData
{
    var unescapedName: String {get}
    var fileURL: NSURL {get}
}

// Doesn't have acutal data in it
public struct File: MultipartFormInputDataType, FileTypeData{
    let unescapedName: String
    public let size: UInt64
    let MIMEType: String
    let fileURL: NSURL
    
    public init?(fileURL: NSURL)
    {
        guard fileURL.fileURL else { return nil }
        
        guard let name = fileURL.lastPathComponent else { return nil }
        
        self.fileURL = fileURL
        unescapedName = name
        MIMEType = mimeTypeForPathExtension(unescapedName)
       
        var num :AnyObject? = nil
        guard let _ = try? fileURL.getResourceValue(&num, forKey: NSURLFileSizeKey) else { return nil }
        
        size = UInt64((num as? NSNumber)?.integerValue ?? 0)
    }
}

extension String: MultipartFormInputDataType{
    public var size: UInt64 {
        return UInt64(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    }
}

public struct Multipart {
    static let boundaryString = "LONGLIVELONGQUADYNASTY"
    static let startingBoundary = "--\(boundaryString)\(Networking.CRLF)"
    static let encapBoundary = "\(Networking.CRLF)--\(boundaryString)\(Networking.CRLF)"
    static let endingBoundary = "\(Networking.CRLF)--\(boundaryString)--\(Networking.CRLF)"
    
    public var contentLength: UInt64 {
        return bodyParts.reduce(0) { $0 + $1.value.size }
    }
    
    public var bodyParts = [(fieldName: String, value: MultipartFormInputDataType)]()
    
    var headers:[String: String] {
        return ["content-type": "multipart/form-data; boundary=\(Multipart.boundaryString)", "content-length": String(contentLength)]
    }
    
    private func subHeaderForBodyPart(fieldName: String, bodypart: MultipartFormInputDataType) -> [String: String]
    {
        var subHeader = ["Content-Disposition": "form-data; name=\"\(fieldName)\""]
        if bodypart is MIMETypedData {
            subHeader["Content-Type"] = (bodypart as! MIMETypedData).MIMEType
        }
        if bodypart is FileTypeData {
            subHeader["Content-Disposition"]! += (bodypart as! FileTypeData).unescapedName
        }
        return subHeader
    }
    
    private func subHeaderData(pair: (String, MultipartFormInputDataType)) -> NSData
    {
        let s = Networking.headersToString(subHeaderForBodyPart(pair.0, bodypart: pair.1))
        return encodeString(s)
    }
    
    private func encodeString(s: String) -> NSData
    {
        return s.dataUsingEncoding(NSUTF8StringEncoding)!
        //no workaround if failed?
    }
    
    public init(){
        
    }
    
    //MARK: Output
    // Smaller files using NSData. Time efficient
    public var data: NSData {
        let output = bodyParts.reduce(NSMutableData()) { accu, newVal in
            let boundary = accu.length > 0 ? Multipart.encapBoundary : Multipart.startingBoundary
            
            accu.appendData(encodeString(boundary))
            accu.appendData(subHeaderData(newVal))
            
            if let data = newVal.value as? FileTypeData{
                accu.appendData(NSData(contentsOfURL:data.fileURL)!)
            }
            return accu
        }
        
        output.appendData(encodeString(Multipart.endingBoundary))
        return output
    }
    
    public var stream: MixedInputStream {
        var output = bodyParts.reduce(MixedInputStream()) {mixedStream, input in
            let boundary = mixedStream.streams.count > 0 ? Multipart.encapBoundary : Multipart.startingBoundary
            var s = mixedStream
            s += NSInputStream(data: encodeString(boundary))
            s += NSInputStream(data: subHeaderData(input))
            
            if let data = input.value as? FileTypeData {
                s += NSInputStream(URL: data.fileURL)!
            }
            return s
        }
        
        output += NSInputStream(data: encodeString(Multipart.endingBoundary))
        return output
    }
    
    public mutating func append(newVal: (String, MultipartFormInputDataType))
    {
        bodyParts.append(newVal)
    }
    
}


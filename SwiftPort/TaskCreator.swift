//
//  NetworkingUpload.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/30/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation



extension Networking {
    
    //upload
	@warn_unused_result(message="Did you forget to call `resume` on the task?")
    static func task(endPoint: APIEndPoint, payload: Any?, header: [String: String]? = nil, session: NSURLSession? = nil, completionHandler:Networking.responseHandler = Networking.defaultResopnseHandler) -> NSURLSessionTask
    {
        let request = NSMutableURLRequest(URL: endPoint.url)
        request.HTTPMethod = endPoint.method.rawValue
        
        let payloadData: Payload?
        if let p = payload {
            if let explictType = endPoint.payloadType {
                payloadData = Payload(type: explictType, data: p)
            } else {
                payloadData = Payload(data: p)
            }
            
            if let d =  payloadData?.dataOrStream as? NSData {
                request.HTTPBody = d
            } else {
                request.HTTPBodyStream = payloadData?.dataOrStream as? NSInputStream
            }
            
        } else {
            payloadData = nil
        }
        
        
        
        for (k, v) in header ?? [:] {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        for (k, v) in payloadData?.headers ?? [:] {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        return (session ?? NSURLSession.sharedSession())
            .dataTaskWithRequest(request, completionHandler: completionHandler)
    }
    
    //decorator
    //create task specific functions
    static func createTargetFunction(endPoint: APIEndPoint, session: NSURLSession? = nil) -> (payload: Any?, completionHandler: Networking.responseHandler?) -> NSURLSessionTask?
    {
        return { data, handler in
            if let h = handler {
                return task(endPoint, payload: data, session: session, completionHandler: h)
            }
            return task(endPoint, payload: data, session: session)
        }
    }
    
    // MARK: User related
    
	//@warn_unused_result(message="Did you forget to call `resume` on the task?")
    static let userRegisterWithUserJSON = Networking.createTargetFunction(CONSTANT.ENDPOINT.USER.REGISTER)
    
	//@warn_unused_result(message="Did you forget to call `resume` on the task?")
    static let userLoginWithUserJSON = Networking.createTargetFunction(CONSTANT.ENDPOINT.USER.FIND_BY_EMAIL)
    
    // MARK: Media upload
    static let mediaUploadWithMultipartFormData = Networking.createTargetFunction(CONSTANT.ENDPOINT.MEDIA.UPLOAD)
    
    static let getAllMediaInfo = Networking.createTargetFunction(CONSTANT.ENDPOINT.MEDIA.ALL_VIDEOS)
}
    

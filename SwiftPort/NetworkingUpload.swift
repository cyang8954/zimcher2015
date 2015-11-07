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
    static func upload(url: NSURL, postData: NetworkingDataType, header: [String: String]? = nil, completionHandler:CompletionHandler = {_,_,_ in }) -> NSURLSessionUploadTask
    {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        switch postData {
        case .JSON: request.HTTPBody = postData.toNSData()
        case .MultipartFormData(let mp): request.HTTPBodyStream = mp.stream()
        }
        
        _ = (header ?? postData.defaultHTTPHeaders).map{(let k, let v) in
            request.setValue(v, forHTTPHeaderField: k)}
        return NSURLSession.sharedSession()
            .uploadTaskWithRequest(request, fromData: nil, completionHandler: completionHandler)
    }
    
    //decorator
    //create task specific functions
    private static func createTargetFunction(URLString: String) -> ((NetworkingDataType, CompletionHandler?) -> NSURLSessionTask?)
    {
        return { data, handler in
            guard let url = NSURL(string: URLString) else { return nil }
            if let h = handler {
                return upload(url, postData: data, completionHandler: h)
            }
            return upload(url, postData: data)
        }
    }
    
    // MARK: User related
    
	//@warn_unused_result(message="Did you forget to call `resume` on the task?")
    static let userRegisterWithUserJSON = Networking.createTargetFunction(CONSTANT.URL.POST_CREATE_USER)
    
	//@warn_unused_result(message="Did you forget to call `resume` on the task?")
    static let userLoginWithUserJSON = Networking.createTargetFunction(CONSTANT.URL.POST_LOGIN)
    
    //static let videoUploadWithVideoJSON = Networking.createTargetFunction(CONSTANT.URL.POST_UPLOAD_VIDEO)
    static let videoUploadWithMultipartFormData = Networking.createTargetFunction(CONSTANT.URL.POST_UPLOAD_VIDEO)
    
}
    

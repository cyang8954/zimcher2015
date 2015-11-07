//
//  ReactiveNetworking.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/30/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension Networking {
    // MARK: Reactive
    
    static func createAction(function: (payload: NetworkingDataType, completionHandler: CompletionHandler) -> NSURLSessionTask?) -> Action<NetworkingDataType, (NSURLResponse, NSData?), NSError>
    {
        return Action<NetworkingDataType, (NSURLResponse, NSData?), NSError> {payload in
            SignalProducer<(NSURLResponse, NSData?), NSError> {sink, disposable in
                guard let task = function(payload: payload, completionHandler: {data, response, error in
                    if let err = error {
                        sink.sendError(err)
                    } else {
                        sink.sendNext((response!, data))
                        sink.sendCompleted()
                    }
                }) else {
                    sink.sendError(NSError(domain: "NSURL", code: 322, userInfo: [NSLocalizedDescriptionKey: "Not a valid URL"]))
                    return
                }
                
                disposable.addDisposable{ task.cancel() }
                task.resume()
            }
        }
    }
    
    //example
    static var userLoginAction: Action<NetworkingDataType, (NSURLResponse, NSData?), NSError> {
        return createAction(userRegisterWithUserJSON) 
    }
}
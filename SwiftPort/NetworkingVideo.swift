//
//  NetworkingVideo.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/30/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

extension Networking {
    
    static func getAllVideoInfo() {
        guard let url = NSURL(string: CONSTANT.URL.GET_ALL_VIDEOS) else { return }
        let request = NSURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(request) {location, response, error in
            if let err = error {
                print(err)
                return
            }
            
            print(response)
            if let loc = location {
                if let data = NSData(contentsOfURL: loc) {
                    print(try? NSJSONSerialization.JSONObjectWithData(data, options: []))
                }
            }
        }
        
        task.resume()
    }
    
    
    
}

/*
+ (void)updateVideoWithVideoData: (NSData * _Nullable)videoData completionHandler:(SessionTaskCompletion _Nullable) completionHandler{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_POST_UPLOAD_VIDEO]];
    NSData *postData = videoData;
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:postData completionHandler:completionHandler];
    [task resume];
}*/
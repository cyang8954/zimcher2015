//
//  SwiftPortTests.swift
//  SwiftPortTests
//
//  Created by Weiyu Huang on 10/28/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import XCTest
@testable import SwiftPort

class SwiftPortTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailValidation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let emailAddresses = ["kappa123@gmail.com"]
        _ = emailAddresses.map {email in
            XCTAssert(IsValid.email(email) , "Error: \(email)")
        }
        
        
    }
    
    func testUserNameValidation() {
        let validNames = ["kappa123"]
        for name in validNames {
            XCTAssert(IsValid.userName(name), "Error: \(name) should be valid")
        }
    }
    
    func testCreateUser() {
        let json = ["userEmail": "1234@tom.com", "userPassword": "123456"]
        let data = NetworkingDataType.JSON(json)
        let task = Networking.upload(NSURL(string: CONSTANT.URL.POST_CREATE_USER)!, postData: data)
        task.resume()
    }
    
    
    func testUserLogin() {
        let expectation = expectationWithDescription(__FUNCTION__)
        
        let json = ["userName": "name", "userEmail": "1234@tom.com", "userPassword": "123456"]
        let data = NetworkingDataType.JSON(json)
        
        let action = Networking.createAction(Networking.userLoginWithUserJSON)
        action.apply(data).startWithNext{
            //XCTAssertNil($0, "\(try? NSJSONSerialization.JSONObjectWithData($0.1!, options: []) )")
            //XCTAssert(($0.0 as? NSHTTPURLResponse)?.statusCode == 200, "\($0)")
            XCTAssert(($0.0 as? NSHTTPURLResponse)?.statusCode == 200, "\($0)")
            expectation.fulfill()
        }
        
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetAllVideosInfo() {
        
        let expectation = expectationWithDescription(__FUNCTION__)
        guard let url = NSURL(string: CONSTANT.URL.GET_ALL_VIDEOS) else { return }
        let request = NSURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(request) {location, response, error in
            if let err = error {
                XCTFail("\(err)")
                return
            }
            
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? 0
            XCTAssert(statusCode == 200, "\(response)")
            if let loc = location {
                if let data = NSData(contentsOfURL: loc) {
                    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    XCTAssertFalse(json != nil, "\(json)")
                }
            }
            expectation.fulfill()
        }
        
        task.resume()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testMIME()
    {
        let exts = ["pdf", "jpeg", "png", "mp4", "c", "swift"]
        for e in exts {
            XCTFail(mimeTypeForPathExtension(e))
        }
        
    }
    
    func testStream()
    {
        var bytesRead = 0
        
        let s = ([UInt](0 ... 40000)).map{$0.description}.joinWithSeparator(" ")
        let stream = NSInputStream(data: "faaaaaaaaa".dataUsingEncoding(NSUTF8StringEncoding)!)
        var mixed = MixedInputStream()
        /*
        mixed += stream
        mixed.open()
        XCTAssert(mixed.streamStatus == .Open, "mixed should be open")
        XCTAssert(mixed.currentStream.streamStatus == .Open, "current should be open")
*/
        class kappa:NSObject, NSStreamDelegate {
            @objc func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
                XCTFail(eventCode.rawValue.description)
            }
        }
        let f = kappa()
        stream.delegate = f
        let bufferLen = 32767
        var buffer = [UInt8](count: bufferLen, repeatedValue: 0)
        
        stream.open()
        bytesRead = stream.read(&buffer, maxLength: bufferLen)
        XCTFail(bytesRead.description)
        var out = NSString(bytes: buffer, length: bytesRead, encoding: NSUTF8StringEncoding)!
        XCTFail(out as String)
        
    }
    
    func testMP()
    {
        var mp = Multipart()
        mp.appendField("userid", value: "18")
        mp.appendField("channelid", value: "3")
        mp.appendField("videoname", value: "Chi Long Qua Dumstering Kids")
        //mp.appendField("lll", value: ([UInt](0 ... 40000)).map{$0.description}.joinWithSeparator(""))
        let st = mp.stream()
        
        let bufferLen = 32768
        var buffer = [UInt8](count: bufferLen, repeatedValue: 0)
        
        st.open()
        var bytesRead = st.read(&buffer, maxLength: bufferLen)
        XCTFail("\(bytesRead)")
        var s = NSString(bytes: buffer, length: bytesRead, encoding: NSUTF8StringEncoding)
        XCTFail(s as? String ?? "")
        
    }
    
    func testMPScheduleToRL()
    {
      var mp = Multipart()
        mp.appendField("userid", value: "18")
        mp.appendField("channelid", value: "3")
        mp.appendField("videoname", value: "Chi Long Qua Dumstering Kids")
        let st = mp.stream()
        
        let bufferLen = 1024
        var buffer = [UInt8](count: bufferLen, repeatedValue: 0)
        var context = CFStreamClientContext(version: 0, info: nil,
            retain: {x in
                XCTFail("retain")
                return x },
            release: {_ in
                XCTFail("release")
            }, copyDescription: nil)
        
        func callback(stream: CFReadStream!, events: CFStreamEventType, ptr: UnsafeMutablePointer<Void>)
        {
            XCTFail("test")
        }
        
        let requestedEvents: CFStreamEventType = [CFStreamEventType.HasBytesAvailable , CFStreamEventType.ErrorOccurred , CFStreamEventType.EndEncountered]
        if(CFReadStreamSetClient(st, requestedEvents.rawValue, callback, &context)) {
            CFReadStreamScheduleWithRunLoop(st, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
        }
        
    }
    
    func testSyncUploadMultipart()
    {
        var mp = Multipart()
        mp.appendField("userId", value: "18")
        mp.appendField("channelId", value: "3")
        mp.appendField("videoName", value: "Stream Video Upload")
        var url = NSURL(fileURLWithPath: "/users/Kappa/Pictures/CLQ.jpg")
        //mp.appendField("image", value: File(nullableFileURL: nil)!)
        
        mp.appendField("image", value: File(nullableFileURL: url)!)
        let s = [UInt](0 ... 30000).map {$0.description}.joinWithSeparator(",")
        mp.appendField("image", value: s)
        
        url = NSURL(fileURLWithPath: "/users/Kappa/Pictures/power.jpg")
        //mp.appendField("video", value: File(nullableFileURL: url)!)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: CONSTANT.URL.POST_UPLOAD_VIDEO)!)
        //let request = NSMutableURLRequest(URL: NSURL(string: "http://putsreq.com/eIjz0BIWQJMjGk3x0zLb")!)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://requestb.in/1a3e17m1")!)
        
        
        request.HTTPMethod = "POST"
        request.HTTPBodyStream = mp.stream()
        
        for (k, v) in mp.headers { request.setValue(v, forHTTPHeaderField: k) }
        
        var response: NSURLResponse?
        let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        
        XCTAssert((response as? NSHTTPURLResponse)?.statusCode ?? 0 == 200, "\(response)")
        if let d = data {
            XCTAssert(NSString(data: d, encoding: NSUTF8StringEncoding)! as String == "ok", "Error")
        }
    }
    
    func testUploadMultipartFormData()
    {
        let expectation = expectationWithDescription(__FUNCTION__)
        var mp = Multipart()
        mp.appendField("userid", value: "18")
        mp.appendField("channelid", value: "3")
        mp.appendField("videoname", value: "Chi Long Qua Dumstering Kids")
        var url = NSURL(fileURLWithPath: "/users/Kappa/Pictures/CLQ.jpg")
        mp.appendField("image", value: "")
        
        url = NSURL(fileURLWithPath: "/users/Kappa/Pictures/power.jpg")
        //mp.appendField("video", value: File(fileURL: url)!)
        mp.appendField("video", value: "")
        
        let task = Networking.videoUploadWithMultipartFormData(NetworkingDataType.MultipartFormData(mp)) {data, response, error in
            XCTAssertNil(error, error?.debugDescription ?? "")
            XCTFail("\(response)")
            XCTAssert((response as? NSHTTPURLResponse)?.statusCode ?? 0 == 200, response.debugDescription)
            
            XCTFail("\(try? NSJSONSerialization.JSONObjectWithData(data!, options: []))")
            expectation.fulfill()
        }
        task?.resume()
        
        waitForExpectationsWithTimeout(80.0, handler: nil)
    }
    
    func test() {
        let expectation = expectationWithDescription(__FUNCTION__)
        let json = ["userName": "name", "userEmail": "1234@tom.com", "userPassword": "123456"] as NSDictionary
        let task = Networking.userLoginWithUserJSON(NetworkingDataType.JSON(json)) { data, response, error in
            expectation.fulfill()
            
        }
        task?.resume()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            

            // Put the code you want to measure the time of here.
        }
    }
    
}

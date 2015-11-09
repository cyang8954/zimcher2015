//
//  DataStream.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/3/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

func += (inout currentStream: MixedInputStream, stream: MixedInputStream)
{
    currentStream.streams += stream.streams
}

func += (inout currentStream: MixedInputStream, stream: NSInputStream)
{
    currentStream.streams.append(stream)
}

class MixedInputStream: NSInputStream, NSStreamDelegate {
    
    var streams = [NSInputStream]()
    var streamsIdx = 0
    weak var _delegate: NSStreamDelegate?
    var _error: NSError?
    var _streamStatus = NSStreamStatus.NotOpen
    
    var currentStream: NSInputStream? {
        return streams.isEmpty ? nil : streams[streamsIdx]
    }
    
    override var delegate: NSStreamDelegate? {
        get { return _delegate }
        set { _delegate = newValue ?? self }
    }
    
    override var streamStatus: NSStreamStatus {
        return _streamStatus
    }
    
    override var streamError: NSError? {
        get { return _error }
        set { _error = newValue }
    }
    
    init() {
        super.init(data: NSData())
        //FailFish
    }
        func doRead(buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard streamStatus == .Open else { return -1 }
        
        guard len > 0 else {
            //maxLength exhausted
            return 0
        }
        
        let bytesRead = currentStream!.read(buffer, maxLength: len)
        
        guard bytesRead >= 0 else {
            streamError = currentStream!.streamError
            _streamStatus = .Error
            currentStream!.close()
            return bytesRead
        }
        
        //sub-stream read succeeded
        let remainingBytes = len - bytesRead
        
        if currentStream!.hasBytesAvailable {
            //the only possibility here: maxLength exhausted
            //no remainingBytes
            return bytesRead
        }
        
        currentStream!.close()
        //current stream ended but client wants more. Needs to switch
        //continued
        
        guard streamsIdx < streams.count-1 else {
            //end of all streams reached
            return bytesRead
        }
        
        ++streamsIdx //next stream
        currentStream!.open()
        //print("Stream idx \(streamsIdx) of \(streams.count-1) Open For Read")
        let nextBytesRead = doRead(buffer + bytesRead, maxLength: remainingBytes)
        
        guard nextBytesRead  >= 0 else { return nextBytesRead } //error propagates
        return bytesRead + nextBytesRead
    }
   
    var hasReachedEnd: Bool {
        guard let stream = currentStream else { return true }
        if streamsIdx == streams.count - 1 && !stream.hasBytesAvailable {
            return true
        }
        return false
    }
  
    
    override var hasBytesAvailable: Bool {
        return !hasReachedEnd
    }
    
    //MARK: function overrides
    override func open() {
        guard _streamStatus == .NotOpen else { return }
        
        if let cs = currentStream {
            _streamStatus = .Open
            cs.open()
        }
    }
    
    override func close() {
        _streamStatus = .Closed
        currentStream?.close()
        //print("> Stream Closed")
    }
    
    //Not thread-safe
    override func read(buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        //_streamStatus = .Reading
        let rb = doRead(buffer, maxLength: len)
        
        if hasReachedEnd {
            _streamStatus = .AtEnd
        }
        return rb
    }
    

    
    // MARK: We don't ship junk JobsFace 4Head EleGiggle
    //
    //         ░░░░░░░░░
    //    ░░░░▄▀▀▀▀▀█▀▄▄▄▄░░░░
    //    ░░▄▀▒▓▒▓▓▒▓▒▒▓▒▓▀▄░░
    //    ▄▀▒▒▓▒▓▒▒▓▒▓▒▓▓▒▒▓█░
    //    █▓▒▓▒▓▒▓▓▓░░░░░░▓▓█░
    //    █▓▓▓▓▓▒▓▒░░░░░░░░▓█░
    //    ▓▓▓▓▓▒░░░░░░░░░░░░█░
    //    ▓▓▓▓░░░░▄▄▄▄░░░▄█▄▀░
    //    ░▀▄▓░░▒▀▓▓▒▒░░█▓▒▒░░
    //    ▀▄░░░░░░░░░░░░▀▄▒▒█░
    //    ░▀░▀░░░░░▒▒▀▄▄▒▀▒▒█░
    //    ░░▀░░░░░░▒▄▄▒▄▄▄▒▒█░
    //    ░░░▀▄▄▒▒░░░░▀▀▒▒▄▀░░
    //    ░░░░░▀█▄▒▒░░░░▒▄▀░░░
    //    ░░░░░░░░▀▀█▄▄▄▄▀░░░

    func _setCFClientFlags(inFlags: CFOptionFlags, callback: CFReadStreamClientCallBack!, context: UnsafeMutablePointer<CFStreamClientContext>) -> Bool
    {
        return false
    }
    
    func _scheduleInCFRunLoop(runLoop: CFRunLoopRef, forMode aMode:CFStringRef) { }

    
    func _unscheduleFromCFRunLoop(runLoop: CFRunLoopRef, forMode aMode:CFStringRef) { }
    
    
    // MARK: Input
    func append(stream: NSInputStream)
    {
        streams.append(stream)
    }
    
    
    deinit
    {
        if streamStatus != .Closed {
            close()
        }
    }
    
 
}


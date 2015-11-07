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

public class MixedInputStream: NSStream, NSStreamDelegate{
    
    public var streams = [NSInputStream]()
    var _status = NSStreamStatus.NotOpen
    var _delegate: NSStreamDelegate? = nil
    public var streamsIdx = 0
    public var currentStream: NSInputStream {
        return streams[streamsIdx]
    }
    
    public override init()
    {
    }
    
    override public var streamStatus: NSStreamStatus {
        return _status
    }
    public var hasBytesAvailable: Bool {
        return (streamsIdx != streams.count - 1) || (streams.last?.hasBytesAvailable ?? false)
    }
    
    public override func open()
    {
        if _status == .NotOpen {
            _status = .Open
            currentStream.open()
        }
    }
    
    public override func close()
    {
        _status = .Closed
        currentStream.close()
    }
    
    //MARK: function overrides
    public func read(buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        
        guard streamStatus == .Open else { return -1 }
        
        guard len > 0 else { return 0 }
        
        let bytesRead = currentStream.read(buffer, maxLength: len)
        
        guard bytesRead > 0 else { return bytesRead }
        
        buffer
        currentStream.close()
        guard streamsIdx < streams.count-1 else { return bytesRead } //end of all streams reached
        ++streamsIdx
        
        currentStream.open()
        let remainingBytes = len - bytesRead
        let nextBytesRead = read(buffer + bytesRead, maxLength: remainingBytes)
        
        guard nextBytesRead  >= 0 else { return nextBytesRead } //error propagates
        return bytesRead + nextBytesRead
    
    }
    
    
    func getBuffer(buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return false
    }
    
    //the only insertion necessary is append
    public func append(stream: NSInputStream)
    {
        streams.append(stream)
    }
    
 
}
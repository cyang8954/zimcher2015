//
//  MIME.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 11/3/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation
import MobileCoreServices

func mimeTypeForPathExtension(pathExtension: String) -> String
{
    if let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
        contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
    {
        return contentType as String
    }
    
    return "application/octet-stream"
}

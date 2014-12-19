//
//  NSFileManager+Extensions.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/5/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import Foundation

extension NSFileManager {
    
    func applicationSupportDirectory() -> NSURL {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        var appSupport =  urls.last as NSURL
        
        var error: NSError? = nil
        if !appSupport.checkResourceIsReachableAndReturnError(&error) {
            var fsError: NSError? = nil
            var ok = NSFileManager.defaultManager().createDirectoryAtURL(appSupport, withIntermediateDirectories: true, attributes: nil, error: &fsError)
            assert(ok == true, "Unable to create app support directory \(fsError!.localizedDescription)")
        }
        return appSupport
    }
}
//
//  DataStoreManager.swift
//  PhotoStream
//
//  Created by HDimes on 10/14/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

internal class DataStoreManager {
    
    var maxCacheSize:UInt = 0 {
        didSet {
            cache.totalCostLimit = Int(maxCacheSize)
        }
    }
    
    private let cache: NSCache<NSString, NSData>
    
    internal init() {
        cache = NSCache<NSString, NSData>()
        cache.totalCostLimit = Int(maxCacheSize)
    }
    
    func data(forUrl url: URL) -> Data? {
        let urlNSString = NSString(string: url.absoluteString)
        if let nsdata = cache.object(forKey: urlNSString) {
            let data = nsdata as Data
            return data
        }
        return nil
    }
    
    func store(data: Data, forUrl url: URL) {
        cache.setObject(data as NSData, forKey: NSString(string: url.absoluteString), cost: 1)
    }
}

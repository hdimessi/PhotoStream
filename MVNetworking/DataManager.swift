//
//  NetworkingManager.swift
//  PhotoStream
//
//  Created by HDimes on 10/14/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

public typealias DataCompletionClosure = (_ data: Data?, _ error:Error?) -> ()

public class DataManager {
    
    public static let shared = DataManager()
    
    private let dataStore: DataStoreManager
    private let networking: NetworkingManager
    
    private var currentRequests: [URL: [DataRequest]] = [:]
    
    public var concurrentRequest: UInt {
        set {
            networking.concurrentRequest = newValue
        }
        get {
            return networking.concurrentRequest
        }
    }
    
    public var maxCacheSize: UInt {
        set {
            dataStore.maxCacheSize = newValue
        }
        get {
            return dataStore.maxCacheSize
        }
    }
    
    private init() {
        dataStore = DataStoreManager()
        networking = NetworkingManager()
        networking.delegate = self
    }
    
    public func fetchData(forRequestInstance request: DataRequest) {
        if let data = dataStore.data(forUrl: request.url) {
            request.dataCompletionHandler(data, nil)
            return
        }
        
        appendNewRequest(request: request)
        networking.fetchData(atUrl: request.url)
    }
    
    internal func cancelDownload(forRequestInstance request: DataRequest) {
        guard var urlDataRequests = currentRequests[request.url],
            urlDataRequests.contains(request) else {return}
        urlDataRequests.remove(at: urlDataRequests.firstIndex(of: request)!)
        if urlDataRequests.count == 0 {
            networking.cancelDownload(forRequestInstance: request)
        }
    }
    
    private func appendNewRequest(request: DataRequest) {
        var newUrlDataRequests: [DataRequest]
        if let urlDataRequests = currentRequests[request.url] {
            newUrlDataRequests = urlDataRequests
        } else {
            newUrlDataRequests = []
        }
        
        if !newUrlDataRequests.contains(request) {
            newUrlDataRequests.append(request)
        }
        
        currentRequests[request.url] = newUrlDataRequests
    }
}

extension DataManager: NetworkingManagerDelegate {
    
    internal func didFinishFetchin(data: Data?, withError error: Error?, atUrl url: URL) {
        if let data = data {
            dataStore.store(data: data, forUrl: url)
        }
        if let concernedRequests = currentRequests[url] {
            for request in concernedRequests {
                request.dataCompletionHandler(data, error)
            }
        }
        currentRequests[url] = nil
    }
    
}

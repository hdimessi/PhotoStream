//
//  NetworkingManager.swift
//  PhotoStream
//
//  Created by HDimes on 10/14/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

protocol NetworkingManagerDelegate: class {
    func didFinishFetchin(data: Data?, withError error: Error?, atUrl url: URL)
}

private struct ActiveRequest {
    let url: URL
    let dataTask: URLSessionDataTask
}

internal class NetworkingManager {
    
    var concurrentRequest:UInt = 0
    
    private var activeRequests: [ActiveRequest] = []
    private var pendingQueue: [URL] = []
    
    private let defaultSession = URLSession(configuration: .default)
    
    weak var delegate: NetworkingManagerDelegate?
    
    func fetchData(atUrl url: URL) {
        if activeRequests.contains(where: {$0.url == url}) {
            // already downloading the contents of this url
            return
        }
        
        if activeRequests.count >= concurrentRequest && concurrentRequest > 0 {
            if !pendingQueue.contains(url) {
                pendingQueue.append(url)
            }
            return
        }
        
        downloadData(atUrl: url)
    }
    
    private func downloadData(atUrl url: URL) {
        let completionHandler = { [weak self] (data: Data?, error: Error?) in
            self?.activeRequests.removeAll(where: {$0.url == url})
            self?.delegate?.didFinishFetchin(data: data, withError: error, atUrl: url)
            guard let strongSelf = self else { return }
            if strongSelf.pendingQueue.count > 0 {
                strongSelf.downloadData(atUrl: strongSelf.pendingQueue.first!)
                strongSelf.pendingQueue.removeFirst()
            }
        }
        
        let dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
              completionHandler(data, error)
            }
        }
        activeRequests.append(ActiveRequest(url: url, dataTask: dataTask))
        dataTask.resume()
        
    }
    
    func cancelDownload(forRequestInstance request: DataRequest) {
        if let activeRequest = activeRequests.first(where: {$0.url == request.url}) {
            activeRequest.dataTask.cancel()
            activeRequests.removeAll(where: {$0.url == request.url})
        } else {
            pendingQueue.removeAll(where: {$0 == request.url})
        }
    }
}

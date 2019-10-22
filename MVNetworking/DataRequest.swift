//
//  NetworkingRequest.swift
//  PhotoStream
//
//  Created by HDimes on 10/14/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

public class DataRequest: NSObject {
    
    public typealias ImageCompletionClosure = (_ image:UIImage?, _ error: Error?) -> ()
    
    public static func getImage(atUrl url: URL,
                              withCompletionHandler completion:@escaping ImageCompletionClosure) -> DataRequest {
        
        return DataRequest(url: url, completion: completion)
    }
    
    public static func getData(atUrl url: URL,
                              withCompletionHandler completion:@escaping DataCompletionClosure) -> DataRequest {
        
        return DataRequest(url: url, completion: completion)
    }
    
    let url: URL
    let dataCompletionHandler: DataCompletionClosure
    
    private init(url: URL, completion: @escaping ImageCompletionClosure) {
        self.url = url
        self.dataCompletionHandler = { (data: Data?, error: Error?) in
            if data != nil {
                guard let image = UIImage(data: data!) else {
                    let finalError: Error
                    if error == nil {
                        finalError = NSError(domain: "incompatible data", code: 500, userInfo: nil)
                    } else {
                        finalError = error!
                    }
                    completion(nil, finalError)
                    return
                }
                completion(image, nil)
                return
            }
            let finalError: Error
            if error == nil {
                finalError = NSError(domain: "something went wrong", code: 500, userInfo: nil)
            } else {
                finalError = error!
            }
            completion(nil, finalError)
        }
        super.init()
        
        DataManager.shared.fetchData(forRequestInstance: self)
    }
    
    private init(url: URL, completion: @escaping DataCompletionClosure) {
        self.url = url
        self.dataCompletionHandler = completion
        super.init()
        
        DataManager.shared.fetchData(forRequestInstance: self)
    }
    
    public func cancelRequest() {
        DataManager.shared.cancelDownload(forRequestInstance: self)
    }
    
}

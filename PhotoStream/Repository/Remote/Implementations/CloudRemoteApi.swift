//
//  CloudRemoteApi.swift
//  PhotoStream
//
//  Created by HDimes on 10/14/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation
import MVNetworking

class CloudRemoteApi: RemoteAPI {

    func fetchPhotos(lastActivity: Date, _ callback:@escaping ([Photo]?, Error?) -> ()) {
        // api doesnt support paging so it will just return the same thing over and over
        // otherwise I would ve liked to send the lastestActivity + amout as query parameters
        guard let url = URL(string: "http://pastebin.com/raw/wgkJgazE") else {
            #if DEBUG || TEST
            fatalError("something is wrong with the url")
            #else
            callback([], nil)
            return
            #endif
        }
        _ = DataRequest.getData(atUrl: url) { (data, error) in
            if let data = data,
                let photos = try? JSONDecoder().decode([Photo].self, from: data) {
                callback(photos, nil)
            } else {
                if let error = error {
                    callback(nil, error)
                }
                let error = NSError(domain: "something went wrong", code: 500, userInfo: nil)
                callback(nil, error)
            }
        }
    }
    
}

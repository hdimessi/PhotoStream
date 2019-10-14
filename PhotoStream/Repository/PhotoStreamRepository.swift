//
//  PhotoStreamRepository.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class PhotoStreamRepository {
    // MARK: - Properties
    let remoteAPI: RemoteAPI

    // MARK: - Methods
    init(remoteAPI: RemoteAPI) {
      self.remoteAPI = remoteAPI
    }
    
    func fetchPhotos(lastActivity: Date, _ callback: @escaping ([Photo]?, Error?) -> ()){
        remoteAPI.fetchPhotos(lastActivity: lastActivity, callback)
    }
}

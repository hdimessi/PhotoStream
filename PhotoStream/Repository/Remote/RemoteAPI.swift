//
//  RemoteAPI.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

let PHOTOS_PER_PAGE: Int = 20

protocol RemoteAPI {
    func fetchPhotos(lastActivity: Date, _ callback:@escaping ([Photo]?, Error?) -> ())
    static func photosPerPage() -> Int
}

extension RemoteAPI {
    static func photosPerPage() -> Int {
        return PHOTOS_PER_PAGE
    }
}

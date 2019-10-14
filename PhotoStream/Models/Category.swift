//
//  Category.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class Category: NSObject, Codable {
    let id: Int
    let title: String
    let photoCount: Int
    let links: [String: String]
    
    enum CodingKeys:String,CodingKey{
        case id
        case title
        case photoCount = "photo_count"
        case links
    }
    
    init(id: Int, title: String, photoCount: Int, links: [String: String]) {
        self.id = id
        self.title = title
        self.photoCount = photoCount
        self.links = links
    }
}

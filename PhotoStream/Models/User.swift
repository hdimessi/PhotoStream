//
//  User.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class User: NSObject, Codable {
    
    let id: String
    let username: String
    let name: String
    let profileImage: ProfileImage
    let links: [String: String]
    
    enum CodingKeys:String,CodingKey{
        case id
        case username
        case name
        case profileImage = "profile_image"
        case links
    }
    init(id: String, username: String, name: String, profileImage: ProfileImage, links: [String: String]) {
        self.id = id
        self.username = username
        self.name = name
        self.profileImage = profileImage
        self.links = links
    }
}

//
//  Photo.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//


import UIKit

class Photo: NSObject, Codable {
    
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let colorHex: String
    let likes: Int
    let likedBy: Bool
    let owner: User
    let urls: PSImage
    let categories: [Category]
    let links: [String: String]
    
    enum CodingKeys:String,CodingKey{
        case id
        case createdAt = "created_at"
        case width
        case height
        case colorHex = "color"
        case likes
        case likedBy = "liked_by_user"
        case owner = "user"
        case urls
        case categories
        case links
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        colorHex = try values.decode(String.self, forKey: .colorHex)
        likes = try values.decode(Int.self, forKey: .likes)
        likedBy = try values.decode(Bool.self, forKey: .likedBy)
        owner = try values.decode(User.self, forKey: .owner)
        urls = try values.decode(PSImage.self, forKey: .urls)
        categories = try values.decode([Category].self, forKey: .categories)
        links = try values.decode([String: String].self, forKey: .links)
    }
    
    init(id: String, createdAt: String, width: Int, height: Int, colorHex: String, likes: Int, likedBy: Bool, owner: User, urls: PSImage, categories: [Category], links: [String: String]) {
        self.id =  id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.colorHex = colorHex
        self.likes = likes
        self.likedBy = likedBy
        self.owner = owner
        self.urls = urls
        self.categories = categories
        self.links = links
    }
}


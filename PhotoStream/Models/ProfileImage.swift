//
//  ProfileImage.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class ProfileImage: NSObject, Codable {
    let small: String
    let medium: String
    let large: String
    
    init(small: String, medium: String, large: String) {
        self.small = small
        self.medium = medium
        self.large = large
    }
}

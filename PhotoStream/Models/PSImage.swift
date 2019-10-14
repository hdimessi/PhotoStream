//
//  PSImage.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class PSImage: NSObject, Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    
    init(raw: String, full: String, regular: String, small: String, thumb: String) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

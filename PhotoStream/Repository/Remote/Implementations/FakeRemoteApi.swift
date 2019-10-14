//
//  FakeRemoteApi.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

struct FakeSize {
    let height: Int
    let width: Int
}

class FakeRemoteApi: RemoteAPI {

    func fetchPhotos(lastActivity: Date, _ callback: ([Photo]?, Error?) -> ()){
        
        var result: [Photo] = []
        
        let sizes = [FakeSize(height: 810, width: 1080),
                     FakeSize(height: 1001, width: 706),
                     FakeSize(height: 901, width: 706),
                     FakeSize(height: 800, width: 600),
                     FakeSize(height: 900, width: 1200),
                     FakeSize(height: 900, width: 1100),
                     FakeSize(height: 1001, width: 706),
                     FakeSize(height: 680, width: 790),
                     FakeSize(height: 1600, width: 900),
                     FakeSize(height: 720, width: 720),
                     FakeSize(height: 900, width: 600),
                     FakeSize(height: 1000, width: 800)]
        let fakeColors = ["#4287f5",
                          "#f76ff1",
                          "#95e024",
                          "#ffffff",
                          "#000000",
                          "#e0ab09"]
        for i in 1...FakeRemoteApi.photosPerPage() {
            let randomImage = Int.random(in: 1...12)
            let psImage = PSImage(raw: "\(randomImage)".fakePhoto(),
                                  full: "\(randomImage)f".fakePhoto(),
                                  regular: "\(randomImage)r".fakePhoto(),
                                  small: "\(randomImage)s".fakePhoto(),
                                  thumb: "\(randomImage)t".fakePhoto())
            let category = Category(id: i, title: "title\(i)", photoCount: 8, links: [:])
            
            let randomPerson = Int.random(in: 1...6)
            
            let profileImage = ProfileImage(small: "\(randomPerson)s".fakeProfileImage(),
                                            medium: "\(randomPerson)m".fakeProfileImage(),
                                            large: "\(randomPerson)l".fakeProfileImage())
            let randomPersonName = Bundle.main.localizedString(forKey: "fakeUser_\(randomPerson)", value: nil, table: "fakeUserNames")
            
            let randomColor = Int.random(in: 1...6)
            
            result.append(Photo(id: "testId\(i)",
                                createdAt: "2016-05-29T15:42:02-04:00",
                                width: sizes[randomImage - 1].width,
                                height: sizes[randomImage - 1].height,
                                colorHex: fakeColors[randomColor - 1],
                                likes: 12,
                                likedBy: randomImage % 2 == 0,
                                owner: User(id: "fakeUserId",
                                            username: "hdimes",
                                            name: randomPersonName,
                                            profileImage: profileImage,
                                            links: [:]),
                                urls: psImage,
                                categories: [category],
                                links: [:]))
        }
        
        callback(result, nil)
    }
}

extension String {
  
    func fakePhoto(scale: String = "2x") -> String {
        if let filePath = Bundle.main.url(forResource: "fakePhoto_\(self)", withExtension: "png") {
            return filePath.absoluteString
        } else if let filePath = Bundle.main.url(forResource: "fakePhoto_\(self)", withExtension: "jpeg") {
            return filePath.absoluteString
        } else {
            return ""
        }
    }

    func fakeProfileImage(scale: String = "2x") -> String {
        let filePath = Bundle.main.url(forResource: "fakeUser_\(self)", withExtension: "jpeg")
        return filePath?.absoluteString ?? ""
    }
}

//
//  Photo.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit
import SKYKit

class Photo {
    var recordName: String
    var imageUrl: URL?
    
    var likes: Int = 0
    var likesToString: String {
        get {
            if likes == 0 {
                return "No like yet"
            } else if likes == 1 {
                return "\(likes) Like"
            } else {
                return "\(likes) Likes"
            }
        }
    }
    
    init(recordName: String, imageUrl: URL) {
        self.recordName = recordName
        self.imageUrl = imageUrl
    }
    
}

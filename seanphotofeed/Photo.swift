//
//  Photo.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit

class Photo {
    
    var imageUrlString: String?
    
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
    
    init(imageUrlString: String) {
        self.imageUrlString = imageUrlString
    }
    
}

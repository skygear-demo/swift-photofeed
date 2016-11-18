//
//  PhotoHelper.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit
import SKYKit

class PhotoHelper {
    
    static let container = SKYContainer.default()!
    static let publicDB = SKYContainer.default().publicCloudDatabase!
    
    static func upload(imageUrl: URL, onCompletion: @escaping (_ succeeded: Bool) -> Void) {
        guard let asset = SKYAsset(name: "FeedImage",fileURL: imageUrl) else {
            onCompletion(false)
            return
        }
        
        asset.mimeType = "image/png"
        container.uploadAsset(asset, completionHandler: { uploadedAsset, error in
            if let error = error {
                print("Error uploading asset: \(error)")
                onCompletion(false)
            } else {
                if let uploadedAsset = uploadedAsset {
                    print("Asset uploaded: \(uploadedAsset)")
                }
                onCompletion(true)
            }
        })
    }
    
    static func upload(imageData: Data, onCompletion: @escaping (_ succeeded: Bool) -> Void) {
        guard let asset = SKYAsset(data: imageData) else {
            onCompletion(false)
            return
        }
        
        asset.mimeType = "image/jpg"
        container.uploadAsset(asset, completionHandler: { uploadedAsset, error in
            if let error = error {
                print("Error uploading asset: \(error)")
                onCompletion(false)
            } else {
                if let uploadedAsset = uploadedAsset {
                    print("Asset uploaded: \(uploadedAsset)")
                }
                onCompletion(true)
            }
        })
    }
    
    
    static func resize(image: UIImage, maxWidth: CGFloat, quality: CGFloat = 1.0) -> Data? {
        var actualWidth = image.size.width
        var actualHeight = image.size.height
        let heightRatio = actualHeight / actualWidth
        
        print("FROM: \(actualWidth)x\(actualHeight) ratio \(heightRatio)")
        
        if actualWidth > maxWidth {
            actualWidth = maxWidth
            actualHeight = maxWidth * heightRatio
        }
        
        print("TO: \(actualWidth)x\(actualHeight)")
        
        let rect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext(),
            let imageData = UIImageJPEGRepresentation(img, quality) else {
                return nil
        }
        
        return imageData
        
//        return UIImage(data: imageData)
    }
    
}

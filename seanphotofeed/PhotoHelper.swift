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
    
    static func retrieveAll(onCompletion: @escaping (_ result: [Photo]) -> Void) {
        let query = SKYQuery(recordType: "photo", predicate: nil)
//        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
//        query?.sortDescriptors = [sortDescriptor]
        
        var photos = [Photo]()
        
        publicDB.perform(query!, completionHandler: { assets, error in
            if let error = error {
                print("Error retrieving photos: \(error)")
                onCompletion(photos)
            } else {
                guard let assets = assets else {
                    onCompletion(photos)
                    return
                }
                for asset in assets {
                    guard let record = asset as? SKYRecord,
                        let likes = record.object(forKey: "likes") as? Int,
                        let imageAsset = record.object(forKey: "asset") as? SKYAsset else {
                        continue
                    }
                    let photo = Photo(imageUrl: imageAsset.url)
                    photo.likes = likes
                    photos.append(photo)
                }
                onCompletion(photos)
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
                    let photo = SKYRecord(recordType: "photo")
                    photo?.setObject(0, forKey: "likes" as NSCopying)
                    photo?.setObject(uploadedAsset, forKey: "asset" as NSCopying)
                    publicDB.save(photo!, completion: { record, error in
                        if let error = error {
                            // Error saving
                            print("Error saving record: \(error)")
                            onCompletion(false)
                        } else {
                            if let recordID = record?.recordID {
                                print("Saved recor with RecordID: \(recordID)")
                                onCompletion(true)
                            }
                        }
                    })
                } else {
                    onCompletion(false)
                }
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
    }
    
}

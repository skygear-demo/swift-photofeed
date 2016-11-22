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
        let query = SKYQuery(recordType: "photo", predicate: NSPredicate(format: "likes >= 0"))
        let sortDescriptor = NSSortDescriptor(key: "_created_at", ascending: false)
        query?.sortDescriptors = [sortDescriptor]
        
        var photos = [Photo]()
        
//        publicDB.performCachedQuery(query!, completionHandler: { assets, cached, error in
//            if let error = error {
//                print("Error retrieving photos: \(error)")
//                onCompletion(photos)
//            } else {
//                guard let assets = assets else {
//                    onCompletion(photos)
//                    return
//                }
//                for asset in assets {
//                    guard let record = asset as? SKYRecord,
//                        let likes = record.object(forKey: "likes") as? Int,
//                        let imageAsset = record.object(forKey: "asset") as? SKYAsset else {
//                            continue
//                    }
//                    let photo = Photo(id: record.recordID, imageUrl: imageAsset.url)
//                    photo.likes = likes
//                    photos.append(photo)
//                }
//                onCompletion(photos)
//            }
//        })
        
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
                    let photo = Photo(recordName: record.recordID.recordName, imageUrl: imageAsset.url)
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
    
    static func delete(photo: Photo, onCompletion: @escaping (_ succeeded: Bool) -> Void) {
        guard let record = SKYRecord(recordType: "photo", name: photo.recordName) else {
            onCompletion(false)
            return
        }
        
        publicDB.deleteRecord(with: record.recordID, completionHandler: { deletedRecord, error in
            if let error = error {
                print("Error deleting record: \(error)")
                onCompletion(false)
            } else {
                onCompletion(true)
            }
        })
    }
    
    static func addOneLike(to photo: Photo, onCompletion: @escaping (_ result: SKYRecord?) -> Void) {
        guard let record = SKYRecord(recordType: "photo", name: photo.recordName) else {
            onCompletion(nil)
            return
        }
        let newLikes = photo.likes + 1
        record.setObject(newLikes, forKey: "likes" as NSCopying!)
        publicDB.save(record, completion: { savedRecord, error in
            if let error = error {
                print("Error adding like: \(error)")
                onCompletion(nil)
            } else {
                onCompletion(savedRecord)
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

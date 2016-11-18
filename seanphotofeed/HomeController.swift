//
//  HomeController.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit
import SKYKit

class HomeController: UITableViewController {
    
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        presentImagePicker()
    }
    
}

extension HomeController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
//            let resizedImageData = PhotoHelper.resize(image: pickedImage, maxWidth: 1080) {
//            PhotoHelper.upload(imageData: resizedImageData, onCompletion: { succeeded in
//                if succeeded {
//                    print("Upload succeeded")
//                } else {
//                    print("Upload failed")
//                }
//            })
//        }
//        if let imageUrl = info[UIImagePickerControllerReferenceURL] as? URL {
//            PhotoHelper.upload(imageUrl: imageUrl, onCompletion: { succeeded in
//                if succeeded {
//                    print("Upload succeeded")
//                } else {
//                    print("Upload failed")
//                }
//            })
//        }
        if let imageUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            print(imageUrl)
            let asset = SKYAsset(name: "FeedImage", fileURL: imageUrl)
            asset?.mimeType = "image/jpg"
            SKYContainer.default().uploadAsset(asset!, completionHandler: { uploadedAsset, error in
                if let error = error {
                    print("Error uploading asset: \(error)")
                } else {
                    if let uploadedAsset = uploadedAsset {
                        print("Asset uploaded: \(uploadedAsset)")
                    }
                }
            })
        }
        dismiss(animated: true, completion: {
        })
    }
    
}

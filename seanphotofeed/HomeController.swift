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
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        reloadPhotos()
    }
    
    func initialize() {
        let photo1 = Photo(imageUrlString: "https://c8.staticflickr.com/6/5324/9448738591_8ca45b5ea5_b.jpg")
        let photo2 = Photo(imageUrlString: "https://c1.staticflickr.com/1/339/19642117288_f58320ce49_b.jpg")
        let photo3 = Photo(imageUrlString: "https://c8.staticflickr.com/8/7368/16428486631_284ec96742_b.jpg")
        photos = [photo1, photo2, photo3]
    }
    
    func reloadPhotos() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width + 8 + 21 + 20
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        
        let photo = photos[indexPath.row]
        cell.likesLabel.text = photo.likesToString
        
        if let imageUrlString = photo.imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.photoView.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
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
//            let asset = SKYAsset(name: "FeedImage", fileURL: imageUrl)
//            asset?.mimeType = "image/jpg"
//            SKYContainer.default().uploadAsset(asset!, completionHandler: { uploadedAsset, error in
//                if let error = error {
//                    print("Error uploading asset: \(error)")
//                } else {
//                    if let uploadedAsset = uploadedAsset {
//                        print("Asset uploaded: \(uploadedAsset)")
//                    }
//                }
//            })
        }
        dismiss(animated: true, completion: {
        })
    }
    
}

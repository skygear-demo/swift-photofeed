//
//  HomeController.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadPhotos()
    }
    
    func reloadPhotos() {
        PhotoHelper.retrieveAll(onCompletion: { result in
            self.photos = result
            self.tableView.reloadData()
        })
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
        cell.photo = photo
        cell.likesLabel.text = photo.likesToString
        
        cell.photoView.image = UIImage(named: "Placeholder")
        if let imageUrl = photo.imageUrl {
            let request = URLRequest(url: imageUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
            URLSession.shared.dataTask(with: request) { data, response, error in
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
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let resizedImageData = PhotoHelper.resize(image: pickedImage, maxWidth: 1080) {
            PhotoHelper.upload(imageData: resizedImageData, onCompletion: { succeeded in
                if succeeded {
                    print("Upload succeeded")
                } else {
                    print("Upload failed")
                }
            })
        }
        dismiss(animated: true, completion: {
        })
    }
    
}

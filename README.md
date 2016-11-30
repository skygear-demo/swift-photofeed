#swift-photofeed

In this tutorial, we are going to make a photo feed app, using Skygear as the backend.

![iphone](Screenshots/iphone.png)

Before getting started, here are the prerequisites:

- Xcode 8 or above
- Swift 3
- Cocoapods (You can refer to the [guide](https://guides.cocoapods.org/using/getting-started.html))
- A Skygear account (you can sign up [here](https://portal.skygear.io))



## Create New App

After signing up/logging in to the Skygear portal, you can see the screen below.

![portal](Screenshots/portal.png)



To create our photo feed app, just click on the **+ Create New App** box. You will be directed to the app creation page. Name the app **{your_name}photofeed**, in this case I will use the name "vita", so the app name is **vitaphotofeed**.



![portal2](Screenshots/portal2.png)

Click on **Create App** when you are done. You will be directed to the app dashboard. Follow the path *Getting Started > iOS > New App*, you will see the setup guide as shown below.



![portal3](Screenshots/portal3.png)



## Setup the App

For easier setup, we will show the steps here. Since we had **Cocoapods** installed, we will start by scaffolding the app. Open the **Terminal** on your Mac, navigate to the desired folder, and run the scaffolding command:

```sh
pod lib create --silent --template-url=https://github.com/SkygearIO/skygear-Scaffolding-iOS.git "vitaphotofeed"
```

In your case, you will replace *"vitaphotofeed"* with your *"{your_name}photofeed"*.

After finishing scaffolding, we will be prompted with few questions to setup the project:

```sh
What is your name?
> <your_git_username>

What is your email?
> <your_git_email>

What is your skygear endpoint (You can find it in portal)?
Example: https://myapp.skygeario.com
> https://vitaphotofeed.skygeario.com

What is your skygear API key (You can find it in portal)?
Example: dc0903fa85924776baa77df813901efc
> <your-api-key>

What language do you want to use?? [ Swift / ObjC ]
> Swift
```

For name and email, enter the username and email your use for Git. The *skygear endpoint* and *skygear API key* information is located in the portal with the path *Info > Server Detail*. Just copy and paste the values to answer the questions. For language, type in *Swift*.  

Upon answering all the questions, scaffolding will begin. After that, Xcode will open with the project Skygear scaffolded for you. You will be prompted whether to convert the syntax to the lastest Swift. Click on **Convert**.

![xcode](Screenshots/xcode.png)

Next, choose **Convert to Swift 3**, then click **Next**.

![xcode2](Screenshots/xcode2.png)

Tick all the targets, then click **Next**.

![xcode3](Screenshots/xcode3.png)

Finally, click **Save**.

![xcode4](Screenshots/xcode4.png)

You are not done yet, there is still one last step before the project is properly setup. In the Project Navigator of Xcode, open the file *ViewController.swift*, as in the picture below:

![xcode5](Screenshots/xcode5.png)

Then, convert all the NSLog() to print() to make it a Swift syntax.

In *ViewController.swift*, you have the code as below:

```swift
    @IBAction func didTapLogin(_ sender: AnyObject) {
        SKYContainer.default().login(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            NSLog("Logged in as: %@", user)
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapSignup(_ sender: AnyObject) {
        SKYContainer.default().signup(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            NSLog("Signed up as: %@", user)
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapLogout(_ sender: AnyObject) {
        SKYContainer.default().logout { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            NSLog("Logged out")
            self.updateLoginStatus()
        }
    }
```

Replace all the lines with NSLog() with print(), as in below:

```swift
    @IBAction func didTapLogin(_ sender: AnyObject) {
        SKYContainer.default().login(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Logged in as \(user)") // Here
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapSignup(_ sender: AnyObject) {
        SKYContainer.default().signup(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Signed up as \(user)") // And here
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapLogout(_ sender: AnyObject) {
        SKYContainer.default().logout { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Logged out") // And finally here
            self.updateLoginStatus()
        }
    }
```

Now, all the code in the project is of the latest Swift syntax. Before finishing the setup, there is one last thing to do: the **SkyKit** installed by Cocoapods is v0.13.0, which is outdated. To correct these, we are going to install the latest **SkyKit** (v0.19.0) as of the writing of this article.

To do that, open Finder or Terminal and navigate to the project directory. You will see a **Podfile** in this directory.

![finder](Screenshots/finder.png)

Open the Podfile with your favorite text editor, and change the version of **SkyKit** from **v0.13.0** to **v0.19.0**, as shown below:

```ruby
use_frameworks!

target 'vitaphotofeed' do
  pod 'SKYKit', '~> 0.19.0' #Changed from 0.13.0
end
```

Now, we need to install the latest pod by running the following command using **Terminal** on the Podfile directory:

```sh
pod install
```

Finally, we're done setting up the project. You can now re-open the project by double clicking on *{your_name}photofeed.xcworkspace* using **Finder**.

## Laying out the Overall Design

![xcode6](Screenshots/xcode6.png)

The picture above show the storyboard of the photo feed app. We will have a **UINavigationController** as the main navigator of the app, and a **Login UIViewController** as the root controller of the navigation controller. Once the user has logged in, he/she can proceed to the **Home UITableViewController**.

In Xcode, open **Main.storyboard** in the project navigator. By default, the **Login UIViewController** has already been scaffolded for you. What you need to do are:

1. Drag and drop a **UINavigationController** into the storyboard.
2. Detach the connected **UITableViewController** from the **UINavigationController**.
3. Make the **UINavigationController** the initial view controller of the app.
4. Make the **Login UIViewController** the root view controller of the **UINavigationController.**
5. Change the **UINavigationBar title** of the **Login UIViewController** to *"Login"*. Drag and drop a **Bar Button Item** onto the top right of the **UINavigationBar** and name it *"Proceed"*.
6. Change the **UINavigationBar title** of the **Home UITableViewController** to *"Home"*. Drag and drop a **Bar Button Item** onto the top right of the **UINavigationBar** and make it a system icon *Add*.
7. Connect the **Proceed Button** of the **Login UIViewController** to the detached **Home UITableViewController** with a default show segue. (By selecting the **Proceed Button** and *Ctrl + Drag* to the **Home UITableViewController**)

There you go, the overall layout is done!

## Working on Login UIViewController

Most of the logic for the **Login UIViewController** has already been scaffolded for you in the corresponding file **ViewController.swift**. What we need to implement is to show/hide the **Proceed button** after users signed up, logged in, and logged out of the app.

To do this, we will open the side-by-side view. First, open **Main.storyboard**, and select **Login UIViewController**. Then, click on the **Assistant Editor** (the one on top right corner of Xcode, with two circles tangled together). Now you will have a side-by-side view of the storyboard layout of **Login UIViewController** and the logic file **ViewController.swift**.

![xcode7](Screenshots/xcode7.png)

Press **Ctrl** and click on the **Proceed Button** at the same time, then drag it to **ViewController.swift** right below the line:

```swift
@IBOutlet weak var loginStatusLabel: UILabel!
```

Enter the name *"proceedButton"* in the name field of the pop out box, then click **Connect**. You've successfully connected **Proceed Button** to the logic file.

We need to implement the show/hide logic of the **Proceed Button** whenver the login status is updated; therefore, we will write it in the following function:

```swift
func updateLoginStatus() {
        if ((SKYContainer.default().currentUserRecordID) != nil) {
            loginStatusLabel.text = "Logged in"
            loginButton.isEnabled = false
            signupButton.isEnabled = false
            logoutButton.isEnabled = true
            
            proceedButton.title = "Proceed" // 1
            proceedButton.isEnabled = true // 2
        } else {
            loginStatusLabel.text = "Not logged in"
            loginButton.isEnabled = true
            signupButton.isEnabled = true
            logoutButton.isEnabled = false
            
            proceedButton.title = "" // 3
            proceedButton.isEnabled = false // 4
        }
    }
```

Line numbered 1, 2, 3, 4 are what we need to add to the existing function **updateLoginStatus()**. Line 1 and 2 are used to show the **Proceed Button** when users are logged in, while Line 3 and 4 are used to hide the **Proceed Button** when users are not logged in / logged out.

Click and run the app on a simulator. Sign up for an account, or log in if you've already created one. Then, tap on the **Proceed Button**.

![simulator](Screenshots/simulator.png)

You will notice that there is a *"Login"* word at the top left corner of the **Back Button** as in the left picture above. To remove the *"Login"* word, we will add the following lines in **ViewController.swift**, right below the *override func viewDidLoad()*:

```swift
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Remove text from back button on next controller
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationItem.backBarButtonItem = backBarButtonItem
    }
```

Run the app on simulator again. Now you will have a clean back button.

## Give Photo a Structure

A photo is some kind of data we retrieve from the internet. We will retrieve a list of photos from the internet and show them in our app, so we need a structure to store these *photos*. To do that, we will create a **class** for photo. First, create a new file named *"Photo.swift"*:

```swift
import UIKit

class Photo {
    var recordName: String
    var imageUrl: URL?
    var likes: Int = 0
    
    init(recordName: String, imageUrl: URL) {
        self.recordName = recordName
        self.imageUrl = imageUrl
    }   
}
```

Every **Photo** will have a unique identifier, which is the *recordName*. It also contains a *URL* for the its image, and the *number of likes* of for it. The *"init(recordName: String)"* function is used to initialise a **Photo**. To make parsing the *number of likes* for string display easier, we will add a helper variable like this:

```swift
import UIKit

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
```

 The *"likesToString: String"* variable will parse a gramatically correct string whenever it is called. This make our code more tidy.

## Core: the SKYKit

There are few actions we will use Skygear for:

1. Upload photo and create a record
2. Delete photo record
3. Add one like to the double-tapped photo
4. Retrieve all photos to show on Home

To do that, create a new file named *"PhotoHelper.swift"*. We will create a **Helper class** to help us manage these complex operations, so life will be easier. Notice that we also import **SKYKit** below import **UIKit** in this class file:

```swift
import UIKit
import SKYKit

class PhotoHelper {
    
    
}
```

Imagine one user uploading a photo that is 4K to our server. This is going to take an unreasonable amount of time for uploading, retrieving, and taking up too many space to store. Therefore, before we upload the photo, we have to resize it to a proper size. To do that, we will write a resize function in **PhotoHelper**:

```swift
import UIKit
import SKYKit

class PhotoHelper {
    
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
```

The *"static func resize(…)"* function above takes a **UIImage** and resize it according to specified **maximum width** and **quality**. Notice that it is a **static** function, meaning that we can use this function just by calling *PhotoHelper.resize(…)* from anywhere. This function will also return an **image data** of type **Data** for easier uploading to Skygear server.

That is it. Now we can write the functions for the 4 actions for Skygear: *upload, delete, add one like, retrieve*.

Quick Notes:

- We will be using the **Public DB** of Skygear, so that all users can access to all the photos posted
- We are using **onCompletion handler** in the 4 functions below. This is because it takes time for network requests to finish, especially when uploading photos. These 4 functions basically wait for network requests to finish only then return a value. To know more about **onCompletion handle**, you can read [this](https://grokswift.com/completion-handlers-in-swift/).
- In Skygear, a **SKYAsset** and **SKYRecord** are stored differently. Hence, we upload a photo as **SKYAsset**, then only we create a new **SKYRecord** to link to the **SKYAsset**.

```swift
import UIKit
import SKYKit

class PhotoHelper {
    
    static let container = SKYContainer.default()!
    static let publicDB = SKYContainer.default().publicCloudDatabase!
    
    // Action 1: Upload photo and create a record
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
    
    // Action 2: Delete photo record
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
    
    // Action 3: Add one like to photo record
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
    
    // Action 4: Retrieve all photo records
    static func retrieveAll(onCompletion: @escaping (_ result: [Photo]) -> Void) {
        let query = SKYQuery(recordType: "photo", predicate: NSPredicate(format: "likes >= 0"))
        let sortDescriptor = NSSortDescriptor(key: "_created_at", ascending: false)
        query?.sortDescriptors = [sortDescriptor]
        
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
                    let photo = Photo(recordName: record.recordID.recordName, imageUrl: imageAsset.url)
                    photo.likes = likes
                    photos.append(photo)
                }
                onCompletion(photos)
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
```



## Laying out the Design of Home UITableViewController

Before mingling with the storyboard, let's first import the required icons into Xcode. You can download the required icons [here](IconAssets.zip). Once downloaded, open **Images.scassets** in Xcode, then add **Love** and **Placeholder** image assets. Finally, drag and drop the downloaded icons into each of the image asset according to their sizes.

![xcode8](Screenshots/xcode8.png)

Now, it's time to make the layout for our photo feeds. First, open **Main.storyboard**. Then, lay out the design by:

![xcode9](Screenshots/xcode9.png)

1. Drag the height of the **UITableViewCell** to appropriate height. We have a square **UIImageView**, 8px from top, and a **UILabel** 12px below the  **UIImageView**, of height 21px, and 20px to the bottom of the **UITableViewCell**. So the appropriate height for an iPhone 7 (screen width 375px) = *8px + 375px + 12px + 21px + 20px = 436px*
2. Drag and drop a **UIImageView** into the **UITableViewCell**. Add constraints so that the **UIImageView** is 8px from top, 0px to both left and right, and with an aspect ratio of 1:1. For attributes, set the image of the **UIImageView** as the *"Placeholder"* image asset we imported just now. Next, tick on the *Clip To Bounds* option and choose the content mode as *Aspect Fill*.
3. Drag and drop a **UILabel** below the **UIImageView**. Add constraints so that the **UILabel** is 12px below the **UIImageView**, 16px to both left and right, and 20px above the bottom of the **UITableViewCell**. Next, make the text align right, set the font weight to *Medium* and font size to 13, and the content of the text as *"--"*.
4. Drag another **UIImageView** into the **UITableViewCell**. Add constraints so that the **UIImageView** is 125px width by 125px height, centered both vertically and horizontally in the **Placeholder UIImageView**. Next, set the image of the **UIImageView** as the *"Love"* image asset, and choose the content mode as *Aspect Fit*.

## Setup Photo Table View Cell

We have laid out the UI for the **Photo Table View Cell**. Now we need to set up the logic of it. First, create a new file named *"PhotoTableViewCell.swift"*. In the file, declare the class for the **Photo Table View Cell** as followed:

```swift
import UIKit

class PhotoTableViewCell: UITableViewCell {
    
}
```

Now, we have to connect the **Photo Table View Cell** on the storyboard to the one in this *"PhotoTableViewCell.swift"* file. Therefore, in **Main.storyboard**, click on the **Photo Table View Cell**, in its **Identity inspector** select its class as **PhotoTableViewCell**. After that, you can open the **Assistant editor** (side-by-side pane), if *"PhotoTableViewCell.swift"* is not shown automatically on the right pane, you can select it manually. You need to drag and drop each elements of the into the *"PhotoTableViewCell.swift"* as followed:

```swift
import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView! // For the photo image view
    @IBOutlet weak var loveView: UIImageView! // For the love icon image view
    @IBOutlet weak var likesLabel: UILabel! // For the number of likes label
    
}
```

Now, we set up a **double tap gesture recognizer** to the **Photo Table View Cell** to handle the like action from user:

- Hide the **Love icon** when the **Photo Table View Cell** is first loaded.
- Add a **Double tap gesture recognizer** to the content view of the **Photo Table View Cell**
- Add a *"doubleTapped(…)"* function to handle the double tap action from user, which is to animate the **Love icon** and send the *PhotoHelper.addOneLike(…)* request to the server.

```swift
import UIKit

class PhotoTableViewCell: UITableViewCell {

    var photo: Photo?
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var loveView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loveView.isHidden = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(sender:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    func doubleTapped(sender: UITapGestureRecognizer) {
        guard let photo = photo else {
            return
        }
        PhotoHelper.addOneLike(to: photo, onCompletion: { result in
            if let likes = result?.object(forKey: "likes") as? Int {
                photo.likes = likes
                self.likesLabel.text = photo.likesToString
            }
        })
        
        loveView.isHidden = false
        loveView.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.loveView.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
                self.loveView.alpha = 0
            }, completion: { finished in
                self.loveView.isHidden = true
            })
        })
    }

}
```


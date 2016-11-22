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
//
//  ViewController.swift
//  seanphotofeed
//
//  Created by newcseanc on 11/18/2016.
//  Copyright (c) 2016 newcseanc. All rights reserved.
//

import UIKit
import SKYKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginStatusLabel: UILabel!
    
    @IBOutlet weak var proceedButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateLoginStatus()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Remove text from back button on next controller
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func updateLoginStatus() {
        if ((SKYContainer.default().currentUserRecordID) != nil) {
            loginStatusLabel.text = "Logged in"
            loginButton.isEnabled = false
            signupButton.isEnabled = false
            logoutButton.isEnabled = true
            
            proceedButton.title = "Proceed"
            proceedButton.isEnabled = true
        } else {
            loginStatusLabel.text = "Not logged in"
            loginButton.isEnabled = true
            signupButton.isEnabled = true
            logoutButton.isEnabled = false
            
            proceedButton.title = ""
            proceedButton.isEnabled = false
        }
        
    }
    
    func showAlert(_ error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapLogin(_ sender: AnyObject) {
        SKYContainer.default().login(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Logged in as: \(user)")
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapSignup(_ sender: AnyObject) {
        SKYContainer.default().signup(withUsername: usernameField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Signed up as: \(user)")
            self.updateLoginStatus()
        }
    }
    
    @IBAction func didTapLogout(_ sender: AnyObject) {
        SKYContainer.default().logout { (user, error) in
            if (error != nil) {
                self.showAlert(error as! NSError)
                return
            }
            print("Logged out")
            self.updateLoginStatus()
        }
    }
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "login_to_home_segue", sender: self)
    }
    
}


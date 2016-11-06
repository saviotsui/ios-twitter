//
//  LoginViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/26/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSignIn(_ sender: UIButton) {
        TwitterClient.instance.login(success: { () in
            TwitterClient.instance.verifyCredentials(success: { (user) in
                print("SUCCESS: Logged in.")
                User.currentUser = user
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }, failure: { (error) in
                print("ERROR: " + (error?.localizedDescription)!)
            })

        }) { (error) in
            print("ERROR: " + (error?.localizedDescription)!)
        }
    }

}


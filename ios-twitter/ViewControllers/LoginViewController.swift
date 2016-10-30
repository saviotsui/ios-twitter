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

        Twitter.instance.client.deauthorize()
        Twitter.instance.client.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "ios-twitter://oauth")!,
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential?) -> Void in
                print("SUCCESS: token received")

                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + (requestToken?.token)!)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            },
            failure: { (error) in
                print("ERROR: " + (error?.localizedDescription)!)
            })
    }

}


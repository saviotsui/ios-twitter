//
//  ProfileViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftIconFont

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        backgroundImageView.setImageWith(user.profileBackgroundUrl!)
        profileImageView.setImageWith(user.profileUrl!)
        descriptionLabel.text = user.tagLine
        friendsLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        friendsLabel.text = String.fontAwesomeIcon("user")! + " " + String(describing: user.friendsCount!)
        tweetsLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        tweetsLabel.text = String.fontAwesomeIcon("twitter-square")! + " " + String(describing: user.statusesCount!)
        followersLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        followersLabel.text = String.fontAwesomeIcon("users")! + " " + String(describing: user.followersCount!)
        screenNameLabel.text = user.screenName
        nameLabel.text = user.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

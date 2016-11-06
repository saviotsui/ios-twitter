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
    @IBOutlet weak var tweetTable: UITableView!
    
    var user: User!
    fileprivate var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.tweetTable.delegate = self
        self.tweetTable.dataSource = self
        self.tweetTable.estimatedRowHeight = 150
        self.tweetTable.rowHeight = UITableViewAutomaticDimension

        self.backgroundImageView.setImageWith(user.profileBackgroundUrl!)
        self.profileImageView.setImageWith(user.profileUrl!)
        self.profileImageView.layer.cornerRadius = 4
        self.profileImageView.clipsToBounds = true
        self.descriptionLabel.text = user.tagLine
        self.friendsLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        self.friendsLabel.text = String.fontAwesomeIcon("user")! + " " + String(describing: user.friendsCount!)
        self.tweetsLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        self.tweetsLabel.text = String.fontAwesomeIcon("twitter-square")! + " " + String(describing: user.statusesCount!)
        self.followersLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        self.followersLabel.text = String.fontAwesomeIcon("users")! + " " + String(describing: user.followersCount!)
        self.screenNameLabel.text = user.screenName
        self.nameLabel.text = user.name

        refreshTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func refreshTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.instance.userTimeline(screenName: user.screenName!, success: { (tweets) in
            self.tweets = tweets
            self.tweetTable.reloadData()

            print("In UserTimeline")
            for tweet in tweets {
                print(tweet.text!)
                print(tweet.user!.name!)
            }
            refreshControl?.endRefreshing()
            }, failure: { (error) in
                print("In UserTimeline Error")
                print(error!.localizedDescription)

                refreshControl?.endRefreshing()
        })
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-twitter.TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

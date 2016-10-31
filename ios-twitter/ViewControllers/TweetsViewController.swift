//
//  TweetsViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftIconFont

class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var newTweetButton: UIBarButtonItem!

    fileprivate var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.logoutButton.icon(from: .FontAwesome, code: "sign-out", ofSize: 20)
        self.profileButton.icon(from: .FontAwesome, code: "twitter", ofSize: 20)
        self.newTweetButton.icon(from: .FontAwesome, code: "plus", ofSize: 20)

        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        self.tweetTableView.estimatedRowHeight = 150
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension

        refreshTweets()

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTweets(refreshControl:)), for: UIControlEvents.valueChanged)
        tweetTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.instance.homeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tweetTableView.reloadData()

            print("In HomeTimeline")
            for tweet in tweets {
                print(tweet.text)
                print(tweet.user?.name)
            }
            refreshControl?.endRefreshing()
            }, failure: { (error) in
                print("In HomeTimeline Error")
                print(error?.localizedDescription)

                refreshControl?.endRefreshing()
        })
    }

    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.instance.logout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController

        if (navigationController.topViewController is ProfileViewController) {
            let profileViewController = navigationController.topViewController as! ProfileViewController
            profileViewController.user = User.currentUser
        }
    }
}

extension TweetsViewController: UITableViewDelegate {
}

extension TweetsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-twitter.TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

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
    @IBOutlet weak var newTweetButton: UIBarButtonItem!
    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!

    fileprivate var tweets = [Tweet]()
    
    fileprivate var viewTweetController: UIViewController!
    fileprivate var profileViewController: UIViewController!

    var shouldRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.hamburgerMenuButton.icon(from: .FontAwesome, code: "bars", ofSize: 20)
        self.logoutButton.icon(from: .FontAwesome, code: "sign-out", ofSize: 20)
        self.newTweetButton.icon(from: .FontAwesome, code: "plus", ofSize: 20)

        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        self.tweetTableView.estimatedRowHeight = 150
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewTweetController = storyboard.instantiateViewController(withIdentifier: "ViewTweetViewController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")

        if shouldRefresh {
            refreshTweets()
        }

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
                print(tweet.text!)
                print(tweet.user!.name!)
            }
            refreshControl?.endRefreshing()
            }, failure: { (error) in
                print("In HomeTimeline Error")
                print(error!.localizedDescription)

                refreshControl?.endRefreshing()
        })
    }

    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.instance.logout()
    }
    
    @IBAction func onHamburgerMenu(_ sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController

        if (navigationController.topViewController is ProfileViewController) {
            let profileViewController = navigationController.topViewController as! ProfileViewController
            profileViewController.user = User.currentUser
        }
        else if (navigationController.topViewController is ViewTweetViewController) {
            let viewTweetViewController = navigationController.topViewController as! ViewTweetViewController
            let indexPath = tweetTableView.indexPath(for: sender as! TweetCell)
            let data = tweets[(indexPath?.row)!]

            viewTweetViewController.tweet = data
            viewTweetViewController.delegate = self
        }
        else if (navigationController.topViewController is CreateTweetViewController) {
            let createTweetViewController = navigationController.topViewController as! CreateTweetViewController

            let createTweet = CreateTweet(viewTitle: "Create a Tweet")
            createTweetViewController.createTweet = createTweet
            createTweetViewController.delegate = self
        }
    }
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        (viewTweetController as! ViewTweetViewController).tweet = tweets[indexPath.row]
        self.navigationController?.pushViewController(viewTweetController, animated: true)
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-twitter.TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension TweetsViewController: CreateTweetViewControllerDelegate {
    func createTweetViewController(createTweetViewController: CreateTweetViewController, didCreateTweet tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        self.tweetTableView.reloadData()
    }
}

extension TweetsViewController: ViewTweetViewControllerDelegate {
    func viewTweetViewController(viewTweetViewController: ViewTweetViewController, didReplyTweets tweets: [Tweet]) {
        for tweet in tweets {
            self.tweets.insert(tweet, at: 0)
        }
        self.tweetTableView.reloadData()
    }
}

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didTapProfile user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController1 = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController1.user = user
        self.navigationController?.pushViewController(profileViewController1, animated: true)
    }
}

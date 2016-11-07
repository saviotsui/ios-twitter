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
    @IBOutlet weak var newTweetButton: UIBarButtonItem!
    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!

    fileprivate var tweets = [Tweet]()
    
    var viewTweets: ViewTweets!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTweets = viewTweets ?? ViewTweets(shouldRefresh: true, timelineTitle: "Timeline")
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = viewTweets.timelineTitle
        self.hamburgerMenuButton.icon(from: .FontAwesome, code: "bars", ofSize: 20)
        self.newTweetButton.icon(from: .FontAwesome, code: "plus", ofSize: 20)

        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        self.tweetTableView.estimatedRowHeight = 150
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        if viewTweets.shouldRefresh {
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
        
        if (viewTweets.timelineTitle == "Timeline") {
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
        else {
            TwitterClient.instance.mentionsTimeline(success: { (tweets) in
                self.tweets = tweets
                self.tweetTableView.reloadData()
                
                print("In MentionsTimeline")
                for tweet in tweets {
                    print(tweet.text!)
                    print(tweet.user!.name!)
                }
                refreshControl?.endRefreshing()
            }, failure: { (error) in
                print("In MentionsTimeline Error")
                print(error!.localizedDescription)
                
                refreshControl?.endRefreshing()
            })
        }
    }

    @IBAction func onHamburgerButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController

        if (navigationController.topViewController is CreateTweetViewController) {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewTweetController = storyboard.instantiateViewController(withIdentifier: "ViewTweetViewController") as! ViewTweetViewController
        viewTweetController.tweet = tweets[indexPath.row]
        viewTweetController.delegate = self
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

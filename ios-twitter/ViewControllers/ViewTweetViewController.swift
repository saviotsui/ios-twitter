//
//  ViewTweetViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/31/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftIconFont

class ViewTweetViewController: UIViewController {

    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var replyBarButton: UIBarButtonItem!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    weak var delegate: ViewTweetViewControllerDelegate?

    var tweet: Tweet!

    fileprivate var replyTweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hamburgerMenuButton.icon(from: .FontAwesome, code: "bars", ofSize: 20)

        retweetCountLabel.text = String(tweet.retweetCount)
        favoritesCountLabel.text = String(tweet.favouritesCount)

        if (tweet.timestamp != nil) {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let dateString = formatter.string(from: tweet.timestamp!)
            timestampLabel.text = dateString
        }

        tweetTextView.text = tweet.text!
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        nameLabel.text = tweet.user!.name!
        profileImageView.setImageWith(tweet.user!.profileUrl!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        favoriteButton.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        favoriteButton.setTitle(String.fontAwesomeIcon("star"), for: UIControlState.normal)
        retweetButton.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        retweetButton.setTitle(String.fontAwesomeIcon("retweet"), for: UIControlState.normal)
        replyButton.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: 12)
        replyButton.setTitle(String.fontAwesomeIcon("reply"), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburgerButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
        
        if (self.navigationController?.topViewController is TweetsViewController) {
            let tweetsViewController = self.navigationController?.topViewController as! TweetsViewController
            let viewTweetsData = ViewTweets(shouldRefresh: false, timelineTitle: "Timeline")
            tweetsViewController.viewTweets = viewTweetsData
        }
    }

    @IBAction func onRetweet(_ sender: UIButton) {
        if (tweet.retweeted) {
            TwitterClient.instance.unRetweet(tweetId: tweet.id!, success: { (response) in
                print("SUCCESS: unretweeted: id=\(self.tweet.id!)")
                self.tweet.retweetCount -= 1
                self.retweetCountLabel.text = String(self.tweet.retweetCount)
                self.tweet.retweeted = false
            }) { (error) in
                Utilities.displayOKAlert(viewController: self, message: "Unable to unretweet. Please try again.", title: "Uh-oh")
                print("ERROR: " + (error?.localizedDescription)!)
            }
        }
        else {
            TwitterClient.instance.retweet(tweetId: tweet.id!, success: { (response) in
                print("SUCCESS: Retweeted: id=\(self.tweet.id!)")
                self.tweet.retweetCount += 1
                self.retweetCountLabel.text = String(self.tweet.retweetCount)
                self.tweet.retweeted = true
            }) { (error) in
                Utilities.displayOKAlert(viewController: self, message: "Unable to retweet. Please try again.", title: "Uh-oh")
                print("ERROR: " + (error?.localizedDescription)!)
            }
        }

    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if (tweet.favourited) {
            TwitterClient.instance.unfavoriteTweet(tweetId: tweet.id!, success: { (response) in
                print("SUCCESS: Unfavorited: id=\(self.tweet.id!)")
                self.tweet.favouritesCount -= 1
                self.favoritesCountLabel.text = String(self.tweet.favouritesCount)
                self.tweet.favourited = false
            }) { (error) in
                Utilities.displayOKAlert(viewController: self, message: "Unable to unfavorite tweet. Please try again.", title: "Uh-oh")
                print("ERROR: " + (error?.localizedDescription)!)
            }
        }
        else {
            TwitterClient.instance.favoriteTweet(tweetId: tweet.id!, success: { (response) in
                print("SUCCESS: Favorited: id=\(self.tweet.id!)")
                self.tweet.favouritesCount += 1
                self.favoritesCountLabel.text = String(self.tweet.favouritesCount)
                self.tweet.favourited = true
            }) { (error) in
                Utilities.displayOKAlert(viewController: self, message: "Unable to favorite tweet. Please try again.", title: "Uh-oh")
                print("ERROR: " + (error?.localizedDescription)!)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        if (navigationController.topViewController is CreateTweetViewController) {
            let createTweetViewController = navigationController.topViewController as! CreateTweetViewController

            let createTweet = CreateTweet(viewTitle: "Reply to Tweet", replyTweet: tweet)
            createTweetViewController.createTweet = createTweet
            createTweetViewController.delegate = self
        }
    }
}

extension ViewTweetViewController: CreateTweetViewControllerDelegate {
    func createTweetViewController(createTweetViewController: CreateTweetViewController, didCreateTweet tweet: Tweet) {
        self.replyTweets.append(tweet)
    }
}

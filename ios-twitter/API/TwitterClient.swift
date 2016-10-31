//
//  TwitterClient.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    fileprivate static let twitterApiUrl = "https://api.twitter.com"
    fileprivate static let consumerSecret = "gXmMUYSyb9WYndXgkDH7dljdiarjhmaoXc13R1O9bGk9Y9tzP6"
    fileprivate static let consumerKey = "VbIJOMbSsq5FsqmhRHBPuA7er"

    static let instance = TwitterClient(baseURL: URL(string: TwitterClient.twitterApiUrl)!, consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret)!

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?

    func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: login")
        
        loginSuccess = success
        loginFailure = failure

        TwitterClient.instance.deauthorize()
        TwitterClient.instance.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "ios-twitter://oauth")!,
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential?) -> Void in
                print("SUCCESS: token received")
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + (requestToken?.token)!)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)

                success()
            },
            failure: { (error) in
                self.loginFailure?(error)
        })
    }

    func logout() {
        print("TwitterClient: logout")

        User.currentUser = nil
        TwitterClient.instance.deauthorize()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    func handleOpenUrl(url: URL) {
        print("TwitterClient: handleOpenUrl")

        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.instance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(requestToken) -> Void in
            print("SUCCESS: Access token received.")

            self.verifyCredentials(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
                self.loginFailure?(error)
            })

            }, failure: {(error) -> Void in
                self.loginFailure?(error)
        })
    }

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: statuses/home_timeline")

        TwitterClient.instance.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response: Any?) in

            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.TweetsFromArray(dictionaries: tweetDictionaries)

            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure(error)
        })
    }

    func verifyCredentials(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: account/verify_credentials")

        TwitterClient.instance.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response: Any?) in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure(error)
        })
    }

    func postTweet(tweet: String, success: @escaping (_ response: Any?) -> (), failure: @escaping (Error?) -> ()) {
        print("TwitterClient: statuses/update.json")

        TwitterClient.instance.post("1.1/statuses/update.json", parameters: ["status": tweet], progress: nil, success: { (task, response: Any?) in
            success(response)
            }) { (task: URLSessionDataTask?, error: Error?) in
                failure(error)
        }
    }
}

//
//  CreateTweetViewControllerDelegate.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/31/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import Foundation

protocol CreateTweetViewControllerDelegate: class {
    func createTweetViewController(createTweetViewController: CreateTweetViewController, didCreateTweet tweet: Tweet)
}

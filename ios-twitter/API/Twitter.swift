//
//  Twitter.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/29/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class Twitter {
    fileprivate let twitterApiUrl = "https://api.twitter.com"
    fileprivate let consumerSecret = "gXmMUYSyb9WYndXgkDH7dljdiarjhmaoXc13R1O9bGk9Y9tzP6"
    fileprivate let consumerKey = "VbIJOMbSsq5FsqmhRHBPuA7er"

    let client: BDBOAuth1SessionManager

    static let instance = Twitter()

    private init() {
        self.client = BDBOAuth1SessionManager(baseURL: URL(string: twitterApiUrl)!, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
}

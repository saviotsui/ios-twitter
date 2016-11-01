//
//  CreateTweet.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/31/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import Foundation

class CreateTweet {
    var replyTweet: Tweet?
    var viewTitle: String!

    init(viewTitle: String!, replyTweet: Tweet? = nil) {
        self.replyTweet = replyTweet
        self.viewTitle = viewTitle
    }
}

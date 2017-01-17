//
//  ViewsTweets.swift
//  ios-twitter
//
//  Created by Savio Tsui on 11/6/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import Foundation

class ViewTweets {
    var shouldRefresh = true
    var timelineTitle: String?
    
    init(shouldRefresh: Bool!, timelineTitle: String!) {
        self.shouldRefresh = shouldRefresh
        self.timelineTitle = timelineTitle
    }
}

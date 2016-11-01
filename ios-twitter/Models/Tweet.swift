//
//  Tweet.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    var favourited: Bool = false
    var retweeted: Bool = false
    var user: User?

    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favourited = (dictionary["favorited"] as? Bool) ?? false
        retweeted = (dictionary["retweeted"] as? Bool) ?? false

        let timestampString = dictionary["created_at"] as? String
        if (timestampString != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString!)
        }

        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
    }

    class func TweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }

        return tweets
    }
}

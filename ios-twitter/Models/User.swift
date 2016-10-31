//
//  User.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    var location: String?
    var userUrl: String?
    var followersCount: Int?
    var statusesCount: Int?
    var friendsCount: Int?
    var profileBackgroundUrl: URL?

    fileprivate var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if (profileUrlString != nil) {
            self.profileUrl = URL(string: profileUrlString!)
        }
        tagLine = dictionary["description"] as? String
        location = dictionary["location"] as? String
        userUrl = dictionary["url"] as? String
        followersCount = dictionary["followers_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if (profileBackgroundUrlString != nil) {
            self.profileBackgroundUrl = URL(string: profileBackgroundUrlString!)
        }

        self.dictionary = dictionary
    }

    static var userDidLogoutNotification = "UserDidLogout"

    fileprivate static var _currentUser: User?
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                let defaults = UserDefaults.standard
                let userData =  defaults.object(forKey: "currentUserData") as? Data

                if (userData != nil) {
                    let data = try? JSONSerialization.jsonObject(with: userData!, options: [])

                    if (data != nil) {
                        _currentUser = User(dictionary: data as! NSDictionary)
                    }
                }
            }

            return _currentUser
        }
        set(user) {
            _currentUser = user

            let defaults = UserDefaults.standard

            if (user != nil) {
                let data = try! JSONSerialization.data(withJSONObject: (user?.dictionary)! as NSDictionary, options: [])

                defaults.set(data, forKey: "currentUserData")
            }
            else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}

//
//  TweetCellDelegate.swift
//  ios-twitter
//
//  Created by Savio Tsui on 11/6/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import Foundation

protocol TweetCellDelegate: class {
    func tweetCell(tweetCell: TweetCell, didTapProfile user: User)
}

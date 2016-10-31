//
//  TweetCell.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetLabel.text = tweet.text
            timeStampLabel.text = Utilities.timeAgoSinceDate(date: tweet.timestamp!, numericDates: true)
            profileImageView.setImageWith((tweet.user?.profileUrl)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

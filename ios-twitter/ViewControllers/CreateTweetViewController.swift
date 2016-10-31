//
//  CreateTweetViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import AFNetworking

class CreateTweetViewController: UIViewController {
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var numCharactersLabel: UILabel!

    fileprivate let placeholderTweetText = "Tweet something!"
    fileprivate let maxCharacters = 140

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.tweetTextView.textColor = UIColor.lightGray
        self.tweetTextView.alpha = 1.0
        self.tweetTextView.text = placeholderTweetText
        self.tweetTextView.becomeFirstResponder()
        self.tweetTextView.delegate = self

        self.profileImageView.setImageWith((User.currentUser?.profileUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onPostButton(_ sender: UIBarButtonItem) {
        TwitterClient.instance.postTweet(tweet: self.tweetTextView.text, success: { (response) in
            print("SUCCESS: Tweeted: \(self.tweetTextView.text!)")

            // create a new Tweet object and shove it into the Tweet array in TweetsViewController
            var tweet = Tweet(dictionary: response as! NSDictionary)

            self.dismiss(animated: true, completion: nil)
            }) { (error) in
                Utilities.displayOKAlert(viewController: self, message: "Unable to Tweet. Please try again.")
                print("ERROR: " + (error?.localizedDescription)!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateTweetViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == self.tweetTextView && textView.text == placeholderTweetText
        {
            DispatchQueue.main.async {
                self.tweetTextView.selectedRange = NSMakeRange(0, 0);
            }
        }
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView != self.tweetTextView) {
            return true
        }

        let newLength = self.tweetTextView.text.utf16.count + text.utf16.count - range.length
        if newLength > maxCharacters {
            return false
        }
        else if newLength > 0
        {
            if self.tweetTextView.text == placeholderTweetText
            {
                self.tweetTextView.textColor = UIColor.darkText
                self.tweetTextView.alpha = 1.0
                self.tweetTextView.text = ""
            }

            return true
        }
        else
        {
            self.tweetTextView.textColor = UIColor.lightGray
            self.tweetTextView.alpha = 1.0
            self.tweetTextView.text = ""
            textViewDidChange(self.tweetTextView)
            self.tweetTextView.text = placeholderTweetText

            DispatchQueue.main.async {
                self.tweetTextView.selectedRange = NSMakeRange(0, 0);
            }

            return false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        numCharactersLabel.text = "\(maxCharacters - textView.text.utf16.count) characters left"
    }
}

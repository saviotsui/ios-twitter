//
//  Utilities.swift
//  ios-twitter
//
//  Created by Savio Tsui on 10/30/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import Foundation

class Utilities {

    static func displayOKAlert(viewController: UIViewController, message: String) {
        // Show the errorString somewhere and let the user try again.
        let alertController = UIAlertController(title: "Title", message: message, preferredStyle: .alert)

        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)

        viewController.present(alertController, animated: true, completion: nil)
    }

    // time formatter from https://gist.github.com/minorbug/468790060810e0d29545
    static func timeAgoSinceDate(date:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = (now < date) ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)

        if (components.year! >= 2) {
            return "\(components.year!)y"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1y"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)mo"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1mo"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)w"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1w"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)d"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1d"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1h"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)min"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1min"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "Just now"
        }
    }
}

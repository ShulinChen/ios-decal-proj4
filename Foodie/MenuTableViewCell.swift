//
//  MenuTableViewCell.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/20/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var votes : [Int]!

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDetails: UILabel!
    @IBOutlet weak var thumbsUp: UIButton!
    @IBOutlet weak var thumbsDown: UIButton!
}

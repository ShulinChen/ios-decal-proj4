//
//  MainScreen.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/18/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class MainScreen: UIViewController {
    
    @IBOutlet weak var searchFood: UIButton!
    @IBOutlet weak var favoriteRes: UIButton!
    @IBOutlet weak var credits: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchFood?.layer.borderWidth = 2.0
        searchFood?.layer.borderColor = UIColor.blackColor().CGColor
        searchFood?.layer.cornerRadius = 10
        favoriteRes?.layer.borderWidth = 2.0
        favoriteRes?.layer.borderColor = UIColor.blackColor().CGColor
        favoriteRes?.layer.cornerRadius = 10
        credits?.layer.borderWidth = 2.0
        credits?.layer.borderColor = UIColor.blackColor().CGColor
        credits?.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

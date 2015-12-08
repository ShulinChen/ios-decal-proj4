//
//  DishObj.swift
//  Foodie
//
//  Created by Yacov Shemesh on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import Foundation

class DishObj{
    
    let id: String
    let title: String
    let info: String
    var numOfVotes: Int
    
    init(id: String, title: String, info: String, numOfVotes: Int){
        self.id = id
        self.title = title
        self.info = info
        self.numOfVotes = numOfVotes
    }
}
//
//  VoteObj.swift
//  Foodie
//
//  Created by Yacov Shemesh on 12/3/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import Foundation

class VoteObj{
    var positiveVote: Bool!
    var negativeVote: Bool!
    var noVote: Bool!
    
    init(positiveVote: Bool, negativeVote: Bool, noVote: Bool){
        self.positiveVote = positiveVote
        self.negativeVote = negativeVote
        self.noVote = noVote
    }
}
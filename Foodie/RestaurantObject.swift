//
//  RestaurantObject.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/19/15.
//  Copyright © 2015 iOS Decal. All rights reserved.

import Foundation
import UIKit

class RestaurantObject: NSObject, NSCoding {
    
    var name : String
    var address : String
    var rating : Float
    var distance : Float
    var cuisine : String
    var phoneNumber : String?
    var closingTime : String
    var bookmarked : Bool
    var numOfRatings : Int
    var ratingImgURL: String
    var imgURL : String
    var budget : Int
    var webURL : String
    var latitude : Double?
    var longitude : Double?
    var zipCode: String
    var city: String
    var state: String
    
   
    init(name : String, address : String, rating : Float, distance : Float, cuisine : String,
        closingTime : String, numOfRatings : Int, budget : Int, bookmarked : Bool, phoneNumber : String, webURL : String, latitude : Double?, longitude : Double?, imgURL: String, ratingImgURL: String, city: String, zipCode: String, state: String){
            
            self.name = name
            self.address = address
            self.rating = rating
            self.distance = distance
            self.cuisine = cuisine
            self.closingTime = closingTime
            self.numOfRatings = numOfRatings
            self.budget = budget
            self.bookmarked = bookmarked
            self.phoneNumber = phoneNumber
            self.webURL = webURL
            self.latitude = latitude
            self.longitude = longitude
            self.imgURL = imgURL
            self.ratingImgURL = ratingImgURL
            self.city = city
            self.zipCode = zipCode
            self.state = state
    }

    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        self.name = (decoder.decodeObjectForKey("name") as? String)!
        self.address = (decoder.decodeObjectForKey("address") as? String)!
        self.rating = (decoder.decodeObjectForKey("rating") as? Float)!
        self.distance = (decoder.decodeObjectForKey("distance") as? Float)!
        self.cuisine = (decoder.decodeObjectForKey("cuisine") as? String)!
        self.closingTime = (decoder.decodeObjectForKey("closingTime") as? String)!
        self.numOfRatings = (decoder.decodeObjectForKey("numOfRatings") as? Int)!
        self.budget = (decoder.decodeObjectForKey("budget") as? Int)!
        self.bookmarked = (decoder.decodeObjectForKey("bookmarked") as? Bool)!
        self.phoneNumber = (decoder.decodeObjectForKey("phoneNumber") as? String)!
        self.webURL = (decoder.decodeObjectForKey("webURL") as? String)!
        self.latitude = (decoder.decodeObjectForKey("latitude") as? Double)!
        self.longitude = (decoder.decodeObjectForKey("longitude") as? Double)!
        self.imgURL = (decoder.decodeObjectForKey("imageURL") as? String)!
        self.ratingImgURL = (decoder.decodeObjectForKey("ratingImgURL") as? String)!
        self.city = (decoder.decodeObjectForKey("city") as? String)!
        self.zipCode = (decoder.decodeObjectForKey("zipCode") as? String)!
        self.state = (decoder.decodeObjectForKey("state") as? String)!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(address, forKey: "address")
        coder.encodeObject(rating, forKey: "rating")
        coder.encodeObject(distance, forKey: "distance")
        coder.encodeObject(cuisine, forKey: "cuisine")
        coder.encodeObject(closingTime, forKey: "closingTime")
        coder.encodeObject(numOfRatings, forKey: "numOfRatings")
        coder.encodeObject(budget, forKey: "budget")
        coder.encodeObject(bookmarked, forKey: "bookmarked")
        coder.encodeObject(phoneNumber, forKey: "phoneNumber")
        coder.encodeObject(webURL, forKey: "webURL")
        coder.encodeObject(latitude, forKey: "latitude")
        coder.encodeObject(longitude, forKey: "longitude")
        coder.encodeObject(imgURL, forKey: "imageURL")
        coder.encodeObject(ratingImgURL, forKey: "ratingImgURL")
        coder.encodeObject(city, forKey: "city")
        coder.encodeObject(zipCode, forKey: "zipCode")
        coder.encodeObject(state, forKey: "state")
    }
}
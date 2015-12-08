//
//  YelpBusiness.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/25/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//


import UIKit

class YelpBusiness: NSObject {
    let name: String?
    let address: String?
    let imageURL: String?
    let categories: String?
    let distance: Float?
    let ratingImageURL: String?
    let numOfRatings: Int?
    let rating: Float?
    var lat: Double?
    var lon: Double?
    let phone: String?
    let url: String?
    let closed: Bool?
    var city: String?
    var state: String?
    var zipCode: String?
    
//    let review: String?
    
    
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = imageURLString
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let city = location!["city"] as? String
            if city != nil{
                self.city = city
            }else{
                self.city = nil
            }
            
            let state = location!["state_code"] as? String
            if state != nil{
                self.state = state
            }else{
                self.state = nil
            }
            
            let zip = location!["postal_code"] as? String
            if zip != nil{
                self.zipCode = zip
            }else{
                self.zipCode = nil
            }
            
        
        
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
            address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? Float
        if distanceMeters != nil {
            let milesPerMeter: Float = 0.000621371
            distance = milesPerMeter * distanceMeters!
        } else {
            distance = nil
        }
        
  
        let ratingImageURLString = dictionary["rating_img_url"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = ratingImageURLString
        } else {
            ratingImageURL = nil
        }
        
        numOfRatings = dictionary["review_count"] as? Int
        rating = dictionary["rating"] as? Float
        
        
        lat = nil
        if let locationLat = dictionary["location"] as? NSDictionary {
            if let coordinate = locationLat["coordinate"] as? NSDictionary {
                self.lat = (coordinate["latitude"] as! Double)
            }
        }
        
        lon = nil
        if let locationLon = dictionary["location"] as? NSDictionary {
            if let coordinate = locationLon["coordinate"] as? NSDictionary {
                self.lon =  (coordinate["longitude"] as! Double)
            }
        }
        
        phone = dictionary["phone"] as? String
        url = dictionary["mobile_url"] as? String
        closed = dictionary["is_closed"] as? Bool
        
//        if dictionary["reviews"] != nil{
//            review = dictionary["reviews"]![0] as! String
//        } else {
//            review = "N/A"
//        }
        
    }
    
    class func businesses(array array: [NSDictionary]) -> [YelpBusiness] {
        var businesses = [YelpBusiness]()
        for dictionary in array {
            let business = YelpBusiness(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([YelpBusiness]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([YelpBusiness]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
}

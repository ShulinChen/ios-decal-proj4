//
//  YelpClient.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/25/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//


import UIKit

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "zRdWhIxWtEohMHvO2gY5xQ"
let yelpConsumerSecret = "rCXD3qHUkszCgh-ZVJZw-O8aWLg"
let yelpToken = "IOT--Xycd2brm3c3l6P_Iu0KR0HXDlSH"
let yelpTokenSecret = "pX3Ew3LXopoc_7N6cu2P1EGOQMk"


enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, completion: ([YelpBusiness]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([YelpBusiness]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term, "ll": "37.874214,-122.259159"]
        
//        var parameters: [String : AnyObject] = ["term": term, "ll": "37.8743782, -122.2591558"]
        
        
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joinWithSeparator(",")
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        print(parameters, "param")
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(YelpBusiness.businesses(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                completion(nil, error)
        })!
    }
    
    func getUserLocation() {
        

    }
}

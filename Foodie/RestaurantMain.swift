//
//  RestaurantMain.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/19/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//



import UIKit
import MapKit
import Foundation
import CoreLocation
import AddressBook

class RestaurantMain: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var coords: CLLocationCoordinate2D?
    var restaurant: RestaurantObject!
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var numOfReviews: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var closingTime: UILabel!
    @IBOutlet weak var bookmark_btn: UIButton!
    @IBOutlet weak var callNumber: UIButton!
    @IBOutlet weak var mapView: MKMapView!
   
    @IBAction func click(sender: AnyObject) {
        
        let tag = sender.tag
        switch tag{
        case 1:
            //Call restaurant
            if let url = NSURL(string: "tel://\(restaurant.phoneNumber)") {
                UIApplication.sharedApplication().openURL(url)
            }
        case 2:
            //Go to website
            UIApplication.sharedApplication().openURL(NSURL(string: restaurant.webURL)!)
            
        case 3:
            print("case 3 got triggered")
            //problem: it doesnt get saved to favorites immediatly after NSUserDefaults.
            
            //            print(favoriteLists, "lists")
            //            viewDidLoad()
            //            let data = NSUserDefaults.standardUserDefaults().objectForKey("favoriteLists") as? NSData
            //            favoriteLists = (NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [RestaurantObject])!
            //
            //iterate through the list to add the bookmark back on
            
            print(favoriteLists.count, " res before")
            if restaurant.bookmarked == true {
                self.restaurant.bookmarked = false
                bookmark_btn.setImage(UIImage(named: "no_bookmark"), forState: UIControlState.Normal)
                //iterate to find the rest and remove it
                print("unbookmark")
                for var i = 0; i < favoriteLists.count; i++ {
                    if favoriteLists[i].name == restaurant.name {
                        print("remove the duplicate")
                        favoriteLists.removeAtIndex(i)
                        break
                    }
                }
                //                for res in favoriteLists as [RestaurantObject] {
                //                    print(res, "one in the list")
                //                    print(restaurant, "current one")
                //                    if res.name == self.restaurant.name {
                //                        print("remove the duplicate")
                //                    }
                //                }
                //save it for permanant storage
                let data = NSKeyedArchiver.archivedDataWithRootObject(favoriteLists)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "favoriteLists")
                
            }
            else {
                var exist : Bool = false
                for var i = 0; i < favoriteLists.count; i++ {
                    if favoriteLists[i].name == restaurant.name {
                        print("already in fav list")
                        exist = true
                        break
                    }
                }
                //book mark it
                if !exist {
                    print("bookmark")
                    favoriteLists.append(restaurant)
                    self.restaurant.bookmarked = true
                    bookmark_btn.setImage(UIImage(named: "bookmark"), forState: UIControlState.Normal)
                    //                    print(favoriteLists, "list")
                    //store it to the favorite list app. avoid duplicates.
                    //change the star color
                    let data = NSKeyedArchiver.archivedDataWithRootObject(favoriteLists)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "favoriteLists")
                    
                }
            }
            print(favoriteLists.count, " res after")
        default:
            print("MYSTERY BUTTON wink emoticon")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        loadRestaurant()
        
        print("viewDidLoad")
        //iterate to add back the buttons
        for var i = 0; i < favoriteLists.count; i++ {
            if favoriteLists[i].name == restaurant.name {
                print("did put the label back!")
                restaurant.bookmarked = true
                bookmark_btn.setImage(UIImage(named: "bookmark"), forState: UIControlState.Normal)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadRestaurant(){
        if restaurant.bookmarked == true {
            bookmark_btn.setImage(UIImage(named: "bookmark.png"), forState: UIControlState.Normal)
        }
        else{
            bookmark_btn.setImage(UIImage(named: "no_bookmark.png"), forState: UIControlState.Normal)
        }
        
        
        if restaurant.phoneNumber != "N/A"{
            let str : NSMutableString = NSMutableString(string: restaurant.phoneNumber!)
            str.insertString("(", atIndex: 0)
            str.insertString(")", atIndex: 4)
            str.insertString(" ", atIndex: 5)
            str.insertString("-", atIndex: 9)
            callNumber.setTitle(str as String, forState: .Normal)
        }else{
            callNumber.setTitle("", forState: .Normal)
        }
        
        name.text = restaurant.name
        address.text = restaurant.address + ", " + restaurant.city
        numOfReviews.text = String(restaurant.numOfRatings) + " reviews"
        cuisine.text = restaurant.cuisine
        distance.text = String(restaurant.distance) + " mi"
        closingTime.text = "Closing at: " + restaurant.closingTime
        latitude = self.restaurant.latitude
        longitude = self.restaurant.longitude
        
        //Shows a pin at the location of the chosen restaurant
        let locationPinCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationPinCoord
        annotation.title = restaurant.name
        annotation.subtitle = restaurant.address
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    @IBAction func directions(sender: AnyObject) {
        let geoCoder = CLGeocoder()
        
        let addressString = "\(restaurant.address) \(restaurant.city) \(restaurant.state) \(restaurant.zipCode)"
        
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [CLPlacemark]?, error: NSError?) in
                
                if error != nil {
                    print("Geocode failed with error: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0] as! CLPlacemark
                    let location = placemark.location
                    self.coords = location!.coordinate
                    self.showMap()
                }
        })
    }
    
    func showMap() {
        
        let addressDict : [String:String] =
        [kABPersonAddressStreetKey as String: restaurant.address,
            kABPersonAddressCityKey as String: restaurant.city,
            kABPersonAddressStateKey as String: restaurant.state,
            kABPersonAddressZIPKey as String: restaurant.zipCode]
        
        let place = MKPlacemark(coordinate: coords!,
            addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let newLat = (location!.coordinate.latitude + restaurant.latitude!) / 2
        let newLon = (location!.coordinate.longitude + restaurant.longitude!) / 2
        let center = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
}

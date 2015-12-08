//
//  RestaurantsListView.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/18/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class RestaurantsListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var businesses: [YelpBusiness]!

    var restaurant = [RestaurantObject]()
    var restaurant2 = [RestaurantObject]()
    var restaurantFull = [RestaurantObject]()
    
    var resImg: UIImage!
    var budgetBtnPressed: Int!
    var radiusBtnPressed: Int!
    
    @IBOutlet weak var budget_1: UIButton!
    @IBOutlet weak var budget_2: UIButton!
    @IBOutlet weak var budget_3: UIButton!
    @IBOutlet weak var budget_4: UIButton!
    @IBOutlet weak var walk_filter: UIButton!
    @IBOutlet weak var drive_filter: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func click(sender: AnyObject) {
        updateList(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        budgetBtnPressed = 0
        radiusBtnPressed = 0
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        
        YelpBusiness.searchWithTerm("Restaurants", sort: .Distance, categories: nil, deals: nil) { (businesses: [YelpBusiness]!, error: NSError!) -> Void in
            self.businesses = businesses
            for business in businesses {
                var isClosed = false
                let phoneNumber = self.checkForMissingData(business.phone)
                let resObj = RestaurantObject(name: business.name!, address: business.address!, rating: business.rating!, distance: Float(round(10 * business.distance!) / 10), cuisine: business.categories!, closingTime: "11:00 PM", numOfRatings: business.numOfRatings!, budget: 2, bookmarked: false, phoneNumber: phoneNumber, webURL: business.url!, latitude: business.lat, longitude: business.lon, imgURL: business.imageURL!, ratingImgURL: business.ratingImageURL!, city: business.city!, zipCode: business.zipCode!, state: business.state!)
                let query = PFQuery(className: "restaurant")
                query.whereKey("name", equalTo: resObj.name)
                query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    //check if it's closed today, if it is, dont add to the list.
                    if (self.getDayOfWeek() == objects![0]["closed_date"] as! Int) {
                        print("!!!")
                        isClosed = true
                    }
                    if (objects![0]["closed_date"] as! Int == 67) {
                        if (self.getDayOfWeek()! == 6 || self.getDayOfWeek()! == 7) {
                            print("???")
                            isClosed = true
                        }
                    }
                    if error == nil {
                        resObj.budget = objects![0]["budget"] as! Int
                        resObj.closingTime = objects![0]["closing_time"] as! String
                    } else {
                        print("Error:")
                    }
                }
                if (!isClosed) {
                    self.restaurant.append(resObj)
                }
                
            } //end of for loop
            self.restaurantFull = self.restaurant
            self.tableView.reloadData()
        }
    }
    

    func getDayOfWeek()->Int! {
        var date = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        var weekDayString = formatter.stringFromDate(date)
        if (weekDayString == "Saturday") {
            return 6
        } else if (weekDayString == "Sunday") {
            return 7
        }
        return -1
    }
    
    // If nil fn will return "N/A"
    func checkForMissingData(data: String?) -> String!{
        if data != nil{
            return data!
        }
        return "N/A"
    }
    
    //Filter buttons
    func updateList(tag : Int){
        
        if tag < 5{
            
            for(var i = 1; i <= 4; i++){
                if i == tag{
                    let tmpButton = self.view.viewWithTag(tag) as? UIButton
                    tmpButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    tmpButton?.layer.borderWidth = 1.0
                    tmpButton?.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
                    tmpButton?.layer.cornerRadius = 10
                }
                else{
                    let tmpButton = self.view.viewWithTag(i) as? UIButton
                    tmpButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    tmpButton?.layer.borderWidth = 0
                }
            }
        }
        else{
            for(var i = 5; i <= 6; i++){
                if i == tag{
                    let tmpButton = self.view.viewWithTag(tag) as? UIButton
                    tmpButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    tmpButton?.layer.borderWidth = 1.0
                    tmpButton?.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
                    tmpButton?.layer.cornerRadius = 10
                }
                else{
                    let tmpButton = self.view.viewWithTag(i) as? UIButton
                    tmpButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    tmpButton?.layer.borderWidth = 0
                }
            }
        }
        
        restaurant = restaurantFull
        restaurant2.removeAll()
        if tag == 5{
            radiusBtnPressed = 5
            if budgetBtnPressed == 0{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].distance <= 0.3{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            else{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].budget == budgetBtnPressed && restaurant[i].distance <= 0.3{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            
        }
        else if tag == 6{
            radiusBtnPressed = 6
            if budgetBtnPressed == 0{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].distance <= 10{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            else{
                for(var i = 0; i < restaurant.count; i++){
                    
                    if restaurant[i].budget == budgetBtnPressed && restaurant[i].distance <= 10{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            
        }
        else{
            budgetBtnPressed = tag
            if radiusBtnPressed == 0{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].budget == tag{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            else if radiusBtnPressed == 5{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].budget == tag && restaurant[i].distance <= 0.3{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
            else{
                for(var i = 0; i < restaurant.count; i++){
                    if restaurant[i].budget == tag && restaurant[i].distance <= 10{
                        restaurant2.append(restaurant[i])
                    }
                }
            }
        }
        restaurant = restaurant2
        self.tableView.reloadData()
    }
    //end of updataList
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurant.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //creates a cell in the tableView and then loads the items in the cell with
        //fields from restaurant object
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: restaurant[indexPath.row].imgURL)!)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                    if error == nil {
                        cell.resImage.image = UIImage(data: data!)
                        
                    }
            })
        
        let request2: NSURLRequest = NSURLRequest(URL: NSURL(string: restaurant[indexPath.row].ratingImgURL)!)
        NSURLConnection.sendAsynchronousRequest(
            request2, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    cell.resRating.image = UIImage(data: data!)
                    
                }
        })
        
        cell.resTitle.text = self.restaurant[indexPath.row].name
        cell.resAddress.text = self.restaurant[indexPath.row].address + ", " + self.restaurant[indexPath.row].city
        cell.resReviews.text = String(self.restaurant[indexPath.row].numOfRatings) + " reviews"
        cell.resCuisine.text = self.restaurant[indexPath.row].cuisine
        cell.resDistance.text = String(self.restaurant[indexPath.row].distance) + " mi"
        cell.resClosingTime.text = restaurant[indexPath.row].closingTime
        
        activity.stopAnimating()
        return cell
    }
    
    func tableView(tableView: UITableView, selectedItemIndex: NSIndexPath){
        self.performSegueWithIdentifier("showRestaurant", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            
            let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
            let desView: RestaurantMain = tabBarC.viewControllers?.first as! RestaurantMain
            let desView2: RestaurantMenu = tabBarC.viewControllers?.last as! RestaurantMenu
            if let indexPath = self.tableView?.indexPathForCell(sender as! UITableViewCell) {
                
                desView.restaurant = restaurant[indexPath.row]
                desView2.restaurant = restaurant[indexPath.row]
            }
        }
    }
}

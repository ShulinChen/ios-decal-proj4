//
//  FavoritesListController.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/24/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

var favoriteLists = [RestaurantObject]()

class FavoritesListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get table from permanent storage
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("favoriteLists") as? NSData {
            favoriteLists = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [RestaurantObject])!
        }
        
        self.favoriteTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLists.count
    }
    
    
    //Fill content of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.favoriteTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: favoriteLists[indexPath.row].imgURL)!)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    cell.resImage.image = UIImage(data: data!)
                    
                }
        })
        
        let request2: NSURLRequest = NSURLRequest(URL: NSURL(string: favoriteLists[indexPath.row].ratingImgURL)!)
        NSURLConnection.sendAsynchronousRequest(
            request2, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    cell.resRating.image = UIImage(data: data!)
                    
                }
        })
        
        cell.resTitle.text = favoriteLists[indexPath.row].name as String
        cell.resAddress.text = favoriteLists[indexPath.row].address
        cell.resReviews.text = String(favoriteLists[indexPath.row].numOfRatings) + " reviews"
        cell.resCuisine.text = favoriteLists[indexPath.row].cuisine
        
        return cell
    }
    
    
    
    //Enable cell removing
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //remove the color of star
            favoriteLists[indexPath.row].bookmarked = false;
            
            //Remove element selected
            favoriteLists.removeAtIndex(indexPath.row)
            
            
            //Store table to permanent storage
            let data = NSKeyedArchiver.archivedDataWithRootObject(favoriteLists)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "favoriteLists")
            
            //Refresh table
            favoriteTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, selectedItemIndex: NSIndexPath){
        self.performSegueWithIdentifier("showRestaurant", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            
            let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
            let desView: RestaurantMain = tabBarC.viewControllers?.first as! RestaurantMain
            if let indexPath = self.favoriteTableView?.indexPathForCell(sender as! UITableViewCell) {
                
                desView.restaurant = favoriteLists[indexPath.row]
            }
        }
    }
}

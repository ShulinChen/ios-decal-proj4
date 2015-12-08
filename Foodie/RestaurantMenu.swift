//
//  RestaurantMenu.swift
//  Foodie
//
//  Created by Yacov Shemesh on 11/19/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class RestaurantMenu: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var dishVote = [DishObj]()
    var cellVote = [VoteObj]()
    var restaurant: RestaurantObject!
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBAction func click(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! MenuTableViewCell
        let index = self.menuTableView.indexPathForCell(cell)
        
        switch sender.tag{
           
            
            
        case 1:
            //load from cloud
            print("come to case 1")
            if  (getVoteStatus(dishVote[index!.row].title) == "no") {
                cellVote[index!.row].positiveVote == false
                cellVote[index!.row].negativeVote == false
                cellVote[index!.row].noVote == true
            } else if (getVoteStatus(dishVote[index!.row].title) == "down") {
                cellVote[index!.row].positiveVote == false
                cellVote[index!.row].negativeVote == true
                cellVote[index!.row].noVote == false
            } else if (getVoteStatus(dishVote[index!.row].title) == "up") {
                cellVote[index!.row].positiveVote == true
                cellVote[index!.row].negativeVote == false
                cellVote[index!.row].noVote == false
            }
        
            
            if (cellVote[index!.row].positiveVote == true) {
                cellVote[index!.row].positiveVote = false
                cellVote[index!.row].negativeVote = false
                cellVote[index!.row].noVote = true
                button.setImage(UIImage(named: "thumbs_up"), forState: .Normal)
                dishVote[index!.row].numOfVotes -= 1
                downVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "no")
            }
            else if (cellVote[index!.row].negativeVote == true){
                cellVote[index!.row].positiveVote = true
                cellVote[index!.row].negativeVote = false
                cellVote[index!.row].noVote = false
                button.setImage(UIImage(named: "thumbs_up_green"), forState: .Normal)
                dishVote[index!.row].numOfVotes += 2
                upVote(dishVote[index!.row].title)
                upVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "up")
                
            }
            else if (cellVote[index!.row].noVote == true){
                cellVote[index!.row].positiveVote = true
                cellVote[index!.row].negativeVote = false
                cellVote[index!.row].noVote = false
                button.setImage(UIImage(named: "thumbs_up_green"), forState: .Normal)
                dishVote[index!.row].numOfVotes += 1
                upVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "up")
            }
            
        //downvotes
        case 2:
             print("come to case 2")
            if  (getVoteStatus(dishVote[index!.row].title) == "no") {
                cellVote[index!.row].positiveVote == false
                cellVote[index!.row].negativeVote == false
                cellVote[index!.row].noVote == true
            } else if (getVoteStatus(dishVote[index!.row].title) == "down") {
                cellVote[index!.row].positiveVote == false
                cellVote[index!.row].negativeVote == true
                cellVote[index!.row].noVote == false
            } else if (getVoteStatus(dishVote[index!.row].title) == "up") {
                cellVote[index!.row].positiveVote == true
                cellVote[index!.row].negativeVote == false
                cellVote[index!.row].noVote == false
            }
            
            if (cellVote[index!.row].negativeVote == true){
                cellVote[index!.row].negativeVote = false
                cellVote[index!.row].positiveVote = false
                cellVote[index!.row].noVote = true
                button.setImage(UIImage(named: "thumbs_down"), forState: .Normal)
                dishVote[index!.row].numOfVotes += 1
                upVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "no")
            }
            else if (cellVote[index!.row].positiveVote == true){
                cellVote[index!.row].negativeVote = true
                cellVote[index!.row].positiveVote = false
                cellVote[index!.row].noVote = false
                button.setImage(UIImage(named: "thumbs_down_red"), forState: .Normal)
                dishVote[index!.row].numOfVotes -= 2
                downVote(dishVote[index!.row].title)
                downVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "down")
            }
            else if (cellVote[index!.row].noVote == true){
                print("right place")
                cellVote[index!.row].negativeVote = true
                cellVote[index!.row].positiveVote = false
                cellVote[index!.row].noVote = false
                button.setImage(UIImage(named: "thumbs_down_red"), forState: .Normal)
                dishVote[index!.row].numOfVotes -= 1
                 downVote(dishVote[index!.row].title)
                setVoteStatus(dishVote[index!.row], val: "down")
            }
            
        default:
            print("MYSTERY BUTTON ;)")
        }
        
        //need this to update in real-time
        self.menuTableView.reloadData()
        
//        print("Cell Number: ", index!.row)
//        print("Number of Votes: ", dishVote[index!.row].numOfVotes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMenu()
        //wait 0.1 second for asynchronous call.
        delay(0.5) {
            self.menuTableView.reloadData()
        }
    }

    
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    
    func upVote(dishName: String) {
        let query = PFQuery(className: dbName(restaurant.name))
        query.whereKey("DishName", equalTo: dishName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            objects![0].incrementKey("Votes", byAmount: 1)
            objects![0].saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The score key has been incremented
                    print("Great Success by adding 1")
                } else {
                    // There was a problem, check error.description
                    print("Fail by adding 1")
                }
            }
        }
    }
    
    func getVoteStatus(dishName: String) -> String {
        let query = PFQuery(className: dbName(restaurant.name))
        query.whereKey("DishName", equalTo: dishName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            return objects![0]["voteImg"]
        }
        return "soemthing wrong"
    }
    
    func setVoteStatus(dish: DishObj, val: String) {
        let query = PFQuery(className: dbName(restaurant.name))
        query.getObjectInBackgroundWithId(dish.id) {
            (pf: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let pf = pf {
                pf["voteImg"] = val
                pf.saveInBackground()
            }
        }
        
    }
    
    func downVote(dishName: String) {
        let query = PFQuery(className: dbName(restaurant.name))
        query.whereKey("DishName", equalTo: dishName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            objects![0].incrementKey("Votes", byAmount: -1)
            objects![0].saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The score key has been incremented
                    print("Great Success by substracting 1")
                } else {
                    // There was a problem, check error.description
                     print("Fail by substracting 1")
                }
            }


        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMenu(){
        //asynchronous call
        var query : PFQuery =  PFQuery(className: dbName(restaurant.name))
        query.orderByDescending("Votes")
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                for (var i = 0; i < objects?.count; i++) {
                    self.dishVote.append(DishObj(id:objects![i].objectId! as String, title: objects![i]["DishName"] as! String ,info: objects![i]["DishInfo"] as! String, numOfVotes: objects![i]["Votes"] as! Int ))
                    
                    switch (objects![i]["voteImg"] as! String) {
                        case "no":
                            self.cellVote.append(VoteObj(positiveVote: false, negativeVote: false, noVote: true))
                        case "up":
                            self.cellVote.append(VoteObj(positiveVote: true, negativeVote: false, noVote: false))
                        case "down":
                            self.cellVote.append(VoteObj(positiveVote: false, negativeVote: true, noVote: false))
                        default:
                            print("something breaks!")
                    }
//                    self.cellVote.append(VoteObj(positiveVote: false, negativeVote: false, noVote: true))
                }
            }
            else {
                print("Error: ", error)
            }
       }
//       print("End of asycro.......")
       self.menuTableView.reloadData()
    }
    
    func tableView(menuTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dishVote.count
    }
    
    func tableView(menuTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.menuTableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.dishName.text = self.dishVote[indexPath.row].title
//        cell.dishDetails.text = self.dishVote[indexPath.row].info
        cell.dishDetails.text = "Votes: " + String(self.dishVote[indexPath.row].numOfVotes)
        
        if cellVote[indexPath.row].noVote!{
            cell.thumbsUp.imageView?.image = UIImage(named: "thumbs_up")
            cell.thumbsDown.imageView?.image = UIImage(named: "thumbs_down")
        }
        else if cellVote[indexPath.row].positiveVote!{
            cell.thumbsUp.imageView?.image = UIImage(named: "thumbs_up_green")
            cell.thumbsDown.imageView?.image = UIImage(named: "thumbs_down")
        }
        else{
            cell.thumbsUp.imageView?.image = UIImage(named: "thumbs_up")
            cell.thumbsDown.imageView?.image = UIImage(named: "thumbs_down_red")
        }
        
        return cell
    }
    
    func dbName(resName : String) -> String {
        //kind of stupid way of matching two strings..hashcode should be a better way
        if resName.lowercaseString.rangeOfString("gyps") != nil {
            return "GypsysTrattoriaItaliana"
        } else if(resName.lowercaseString.rangeOfString("north") != nil) {
            return "NorthsideCafe"
        } else if(resName.lowercaseString.rangeOfString("pizz") != nil) {
            return "Pizzahhh"
        } else if (resName.lowercaseString.rangeOfString("smoke") != nil) {
            return "smokePoutinerie"
        } else {
            return "Bungo"
        }
    }
}

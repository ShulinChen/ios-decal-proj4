# Foodie Project!
## Authors: 
- Yacov Shemesh,
- Eranda Bregasi, 
- Shulin Chen

### Walkthrough

![Walkthrough](foodie.gif)

## Purpose: 
Foodie allows Cal students to find food/free food in a fast and easy fashion and share their favorite restaurants and dishes with others.

## Features:
- Find food/free food near the student’s location
- Filters places by walk, drive, or public transportation
- Filters places by budget
- Ability to save restuarant/dish to favorites list
- Restaurant menu listed by most voted dishes
- Map and directions for each specific restaurant
- Search results will show only restaurants that are open at the time of the search

## Control Flow:
- In the first screen the users will see the app’s logo 
- The main screen will allow the users to search for food,or go straight to their favorites if any were added to the list.
- Once the user searches for food, a list will appear with the closest restaurants. Each restaurant will have its own cell that includes: Name, distance, closing time, rating (1-5 stars), cuisine and if the restaurant has any special features such as: open late night, fast, has parking and… On the bottom of the screen will be three buttons that will allow the user to change the radius of the search (walking distance - 1.5 miles, driving distance - 20 miles, and public transportation) and three buttons for different budget options.
- After clicking on one of the restaurants, the user will enter the main screen of the specific restaurant he/she chose. The screen will hold all the most important details about the restaurant, a favorites button, the restaurant’s menus and the votes associted with each dish.

## Implementation:

### Model
  
   - (RestaurantObject.swift)Model will contain many JSON objects retrieved from the Yelp API. The JSON object simply represent all the info about a restaurant. User actions in the view layer are communicated through a View Controller and results in the creation or updating of the model object. Also, when a model object changes, it notifies a controller object, which will updates the appropriate view object. Here we will try to integrate the SwiftJSON library to parse JSON.

### View
   - (restaurantListView.swift)Basically a view object will properly display the restaurants from the model objects and enable the editing of those data. Here we will use  a UICollectionView to properly represents each resulting restarant in a UICollectionViewcell. 

### Controller
-  (restaurantsMain.swift)Controller can be thought of as the bridge between view and model. So whenever we send a API query our model will get updated, the controller will then be notified and tell the view object to display the contents of the updated model objects; on the other way, when a user makes some input in the view, say they search the restaurants by different transportation, the controller will be notified and tell model to update the data to match the user request.


### Installation

Run the following in command-line:

```
pod install
open Foodie.xcworkspace
```
    
The following CocoaPods were used:
'AFNetworking', '~> 2.4'
'BDBOAuth1Manager'
'Parse'

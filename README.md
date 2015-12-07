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
- Restaurant review page
- Order to go straight from the app
- Map and directions for each specific restaurant
- Search results will show only restaurants that are open at the time of the search

## Control Flow:
- In the first screen the users will see the app’s logo and immediately after they will be asked to sign in by either their Facebook account or by their email. 
- After signing in, in the first time, the users will be presented with a walk through and guidance for using  the app.
- The main screen will allow the users to search for food, free food, or go straight to their favorites if any were added to the list.
- Once the user searches for food, a list will appear with the closest restaurants. Each restaurant will have its own cell that includes: Name, distance, closing time, rating (1-5 stars), cuisine and if the restaurant has any special features such as: open late night, fast, has parking and… On the bottom of the screen will be three buttons that will allow the user to change the radius of the search (walking distance - 1.5 miles, driving distance - 20 miles, and public transportation). The user will also be able to swipe from the right to open a side panel that includes the options for different budgets.
- After clicking on one of the restaurants, the user will enter the main screen of the specific restaurant he/she chose. The screen will hold all the most important details about the restaurant, a favorites button, order to go button, and images of the restaurant’s dishes.
swiping from the right on the main restaurant screen will show all the reviews of that restaurant.
- Swiping from the left will show the restaurant’s menu listed by the most voted dishes and a thumbs up/down button for the user to rate it.
- Swiping from the bottom will show the map and direction to the restaurant from the user’s current place.



## Implementation:

### Model
  
   - (restaurants.swift)Model will contain many JSON objects retrieved from the Yelp API. The JSON object simply represent all the info about a restaurant. User actions in the view layer are communicated through a View Controller and results in the creation or updating of the model object. Also, when a model object changes, it notifies a controller object, which will updates the appropriate view object. Here we will try to integrate the SwiftJSON library to parse JSON.

### View
   - (restaurantsView)Basically a view object will properly display the restaurants from the model objects and enable the editing of those data. Here we will use  a UICollectionView to properly represents each resulting restarant in a UICollectionViewcell. 

### Controller
-  (restaurantsController)Controller can be thought of as the bridge between view and model. So whenever we send a API query our model will get updated, the controller will then be notified and tell the view object to display the contents of the updated model objects; on the other way, when a user makes some input in the view, say they search the restaurants by different transportation, the controller will be notified and tell model to update the data to match the user request.
    

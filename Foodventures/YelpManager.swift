//
//  YelpManager.swift
//  Foodventures
//
//  Created by Frank Su on 2020-01-06.
//  Copyright © 2020 frankusu. All rights reserved.
//
// https://www.appcoda.com/restful-api-library-swift/
// This tutorial was a great help

//category list https://www.yelp.ca/developers/documentation/v3/category_list


import Foundation
import MapKit

class YelpManager {
    
    
    //MARK: Properties
    let apiKey = "Bearer "
    let yelpApiURL = "https://api.yelp.com/v3/businesses/search"
    
    var searchText : String?
    var coordinate : CLLocationCoordinate2D?
    var latitude : String = ""
    var longitude : String = ""
    
    
    //first lets just pass the string of what we know back to the class and do a simple search eh ?
    
    //make an enumeration for all the search endpoints there are
    //then have a function that passes in the busness endpoint enum .raw value
    //then you can use that one function to decode all of the requests since we can also pass in different structures depending on the type of search request
    //then you can in restauratnsearchtable you can return back the name of the searchText and then populate the table view
    
    //part 2, figure out a way to get the codable into some sort of data structure like array maybe ?
    // or find a away to use the data like how do i even get image ?
    // i need to get category to make the pins appear as icons of food on the map
    // also, how do i implement the search nearby area function ?v
    
    func searchEndPoint() {
        convertCoordinates()
        guard let yelpURL = URL(string: yelpApiURL) else {return}
        let finalYelpURL = yelpURL.addQueryParam("term", value: searchText)
            .addQueryParam("latitude", value: latitude)
            .addQueryParam("longitude", value: longitude)
        
        
        var request = URLRequest(url: finalYelpURL)
        print(request)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if let err = err {
                print("Failed to authenticate restaurant", err)
            }
            
                    if let response = response {
                        print(response)
                    }
            //        guard let data = data else {return}
            //            let string = String(data: data, encoding: .utf8)
            //            print(string)
            
            guard let data = data else {print("No data to be returned");return}
            
            do {
                let businesses = try JSONDecoder().decode(Businesses.self, from: data)
                
                
                let restaurantArray = businesses.businesses
        
                restaurantArray.forEach { (restaurant) in
                    print("------------------------ REST -----------------------")
                    print(restaurant.alias!)
                    
                    restaurant.categories?.forEach({ (category) in
                        print(category.alias!)
                    })
                }
                
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr.localizedDescription)
            }
            
        }.resume()
    }
    
    
}
extension URL {
    func addQueryParam(_ queryKey: String, value: String?) -> URL {
        
        guard var urlComponenets = URLComponents(string: absoluteString) else { return absoluteURL}
        
        //create array of existing query items
        var queryItems: [URLQueryItem] = urlComponenets.queryItems ?? []
        
        //create query item
        let queryItem = URLQueryItem(name: queryKey, value: value)
        
        //append the new query item into existing query items array
        queryItems.append(queryItem)
        
        //append updated query items array in the url componenet object
        urlComponenets.queryItems = queryItems
        
        //returns the url from new url components
        return urlComponenets.url!
    }
}
extension YelpManager{
    
    func convertCoordinates() {
        if let coordinate = coordinate{
            let doubleLat = Double(coordinate.latitude)
            let doubleLong = Double(coordinate.longitude)
            latitude = doubleLat.toString()
            longitude = doubleLong.toString()
        }
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.14f", self)
    }
}
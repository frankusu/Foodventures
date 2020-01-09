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
    let apiKey = "Bearer your_api_key"
    let yelpApiURL = "https://api.yelp.com/v3/businesses/search"
    
    var searchText : String?
    var coordinate : CLLocation?

    
    func searchEndPoint() {
        guard let yelpURL = URL(string: yelpApiURL) else {return}
        
        var request = URLRequest(url: yelpURL.appendingPathComponent(searchText!))
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        //I need URLComponents to addcomponents to URLQueryItem
        request.addValue("latitude", forHTTPHeaderField: coordinate?.coordinate.latitude as String)
        request.addValue("longtitude", forHTTPHeaderField: coordinate?.coordinate.longitude as String)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
        
        
        
        if let err = err {
        print("Failed to authenticate restaurant", err)
        }
        
//        if let response = response {
//            print(response)
//        }
        guard let data = data else {return}
        //            let string = String(data: data, encoding: .utf8)
        //            print(string)
        
        do {
        let restaurant = try JSONDecoder().decode(Restaurant.self, from: data)
        
        print(restaurant)
        print(restaurant.categories)
        
        } catch let jsonErr{
        print("Error serializing json:", jsonErr.localizedDescription)
        }
        
        }.resume()
    }
    
    
}

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

class Service {
    //singleton - one instance to exist in your program at all times
    static let shared = Service()
    //MARK: Properties
    let searchUrlString = "https://api.yelp.com/v3/businesses/search"
    //apiKey is in untracked git file use apiKey = "Bearer secret_api_string"
    var coordinate : (String,String)?
    func fetchYelp(searchText : String, completion: @escaping ([Restaurant],Error?) -> ()) {
        guard let coordinate = coordinate else { print("Coordinate in service is nil"); return}
        guard let searchUrl = URL(string: searchUrlString) else { return}
        let finalUrl = searchUrl.addQueryParam("term", value: searchText)
            .addQueryParam("latitude", value: coordinate.0 )
            .addQueryParam("longitude", value: coordinate.1)
        var request = URLRequest(url: finalUrl)
        print(request, apiKey)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data,response,error in
            if let error = error {
                completion([],error)
                return
            }

            guard let data = data else {return}
            do {
                let searchResults = try JSONDecoder().decode(Businesses.self, from: data)
                
                completion(searchResults.businesses,nil)
                
                
            } catch {
                print("Error json", error)
                completion([],error)
            }
            
        }.resume()
        
    }
    
//    func searchEndPoint() {
//        convertCoordinates()
//        guard let yelpSearchURL = URL(string: yelpApiURL) else {return}
//        let finalYelpURL = yelpURL.addQueryParam("term", value: searchText)
//            .addQueryParam("latitude", value: latitude)
//            .addQueryParam("longitude", value: longitude)
//
//        var request = URLRequest(url: finalYelpURL)
//        print(request)
//        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { (data, response, err) in
//
//            if let err = err {
//                print("Failed to authenticate restaurant", err)
//            }
//
//                    if let response = response {
//                        print(response)
//                    }
//
//            guard let data = data else {print("No data to be returned");return}
//
//            do {
//                let businesses = try JSONDecoder().decode(Businesses.self, from: data)
//
//
//            } catch let jsonErr{
//                print("Error serializing json:", jsonErr.localizedDescription)
//            }
//
//        }.resume()
//    }
    
    
}
extension URL {
    func addQueryParam(_ queryKey: String, value: String?) -> URL {
        
        guard var urlComponenets = URLComponents(string: absoluteString) else { return absoluteURL}
        
        //create array of existing query items
        var queryItems: [URLQueryItem] = urlComponenets.queryItems ?? []
        
        //create query item
        guard let value = value else { return absoluteURL }
        //Yelp api likes spaces. Don't need PercentEncoding
//        let queryItem = URLQueryItem(name: queryKey, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        let queryItem = URLQueryItem(name: queryKey, value: value)
        
        //append the new query item into existing query items array
        queryItems.append(queryItem)
        
        //append updated query items array in the url componenet object
        urlComponenets.queryItems = queryItems
        
        //returns the url from new url components
        return urlComponenets.url!
    }
}

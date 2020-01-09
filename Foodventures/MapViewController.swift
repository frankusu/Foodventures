//
//  ViewController.swift
//  Foodventures
//
//  Created by Frank Su on 2019-12-29.
//  Copyright © 2019 frankusu. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    
    static let Foodventures = "Foodventures"
    static let SearchPlaceHolder = "Search for a restaurant"
    
    //MARK: Properties
    let locationManager = CLLocationManager()
    var restaurantSearchTable = RestaurantSearchTable()
    lazy var searchController = UISearchController(searchResultsController: restaurantSearchTable)
    
    let apiKey = "Bearer"
    
    struct Restaurant : Decodable {
        let id: String?
        let alias: String?
        let name: String?
        let image_url: URL?
        let categories : [Categories]
        let rating: Double?
        
    }
    
    struct Categories : Decodable {
        let alias : String?
        let title : String?
    }
    
    struct User: Codable {
        
        
        var id: Int?
        var firstName: String?
        var lastName: String?
        var avatar: String?

    }
    
    var selectedPin : MKPlacemark? = nil
    
    let mapView : MKMapView = {
        let map = MKMapView()
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
//        let initialLocation = CLLocation(latitude: 49.246292, longitude: -123.116226)

        
        return map
    }()
    
    private func setUpSearchController() {
        
        restaurantSearchTable.mapView = mapView
        // Assign searchResultsUpdater delegate to restaurantTable
        searchController.searchResultsUpdater = restaurantSearchTable
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.delegate = self //what does this really do ?
        searchController.searchBar.placeholder = MapViewController.SearchPlaceHolder
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        setUpSearchController()
        setUpCurrentLocation()
        setUpViews()
        
        
       
        
        navigationItem.title = MapViewController.Foodventures
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        restaurantSearchTable.handleMapSearchDelegate = self
        
        let yelpApiURL = "https://api.yelp.com/v3/businesses/ramen-danbo-vancouver-3"
//        let yelpApiURL = "https://reqres.in/api/users/1"
        guard let yelpURL = URL(string: yelpApiURL) else {return}
        
        let yelpURLYo = yelpURL.appendingPathComponent("yo1").appendingPathComponent("yo2")
        print(yelpURLYo.absoluteString)
        var request = URLRequest(url: yelpURL)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            
            
            if let err = err {
                print("Failed to authenticate restaurant", err)
            }
            
            if let response = response {
                print(response)
            }
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

    //TODO: How to pass in search parameters to API
    
    //MARK: Methods
    
    func setUpCurrentLocation() {
        // could take time for requested info to come back, use delegate to handle asynch
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }

    private func setUpViews() {
        // add subviews before constraints or throw anchors reference items in different view hierarchies? That's illegal
        view.addSubview(mapView)
    
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}
//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    // Shows user current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

//MARK: - UISearchBarDelegate
extension MapViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - HandelMapSearch
extension MapViewController : HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear exisiting pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}



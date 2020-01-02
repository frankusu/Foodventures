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
    }

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


//MARK: - UISearchControllerDelegate

//// Use these delegate functions for additional control over the search controller.
//
//extension MapViewController : UISearchControllerDelegate {
//    func presentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func willPresentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func didPresentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func willDismissSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func didDismissSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//}

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



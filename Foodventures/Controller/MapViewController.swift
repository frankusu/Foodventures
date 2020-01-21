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
    var resultsViewController = ResultsViewController()
    let regionSpanInMeters : Double = 5000
    lazy var searchController = UISearchController(searchResultsController: resultsViewController)
    let yelpManager = YelpManager()
    var selectedPin : MKPlacemark? = nil
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
//        let initialLocation = CLLocation(latitude: 49.246292, longitude: -123.116226)
        return map
    }()
    
    private func setUpSearchController() {
        
        resultsViewController.mapView = mapView
        // Assign searchResultsUpdater delegate to restaurantTable
        searchController.searchResultsUpdater = restaurantSearchTable
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = MapViewController.SearchPlaceHolder
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        setUpSearchController()
        checkLocationServices()
        setUpViews()

        navigationItem.title = MapViewController.Foodventures
        navigationItem.searchController = searchController
        definesPresentationContext = true
//        restaurantSearchTable.handleMapSearchDelegate = self
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
    //MARK: Location Methods
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they need to turn on system wide location services
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Active restrictions such as parental control or something
            break
        case .authorizedAlways:
            // HIG says don't use this bad boi
            break
            
        @unknown default:
            fatalError("authorizationStatus case not implemented")
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionSpanInMeters, longitudinalMeters: regionSpanInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    
}
//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    // Shows user current location.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionSpanInMeters, longitudinalMeters: regionSpanInMeters)
//        yelpManager.coordinate = location.coordinate
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

//MARK: - UISearchBarDelegate
extension MapViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("MapViewController searchbar Text ",searchBar.text!)
        if let searchText = searchBar.text {
            yelpManager.searchText = searchText
        }
        yelpManager.searchEndPoint()
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



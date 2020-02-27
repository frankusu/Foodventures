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
//    var restaurantSearchTable = RestaurantSearchTable()
    var resultsViewController = ResultsViewController()
    let regionSpanInMeters : Double = 5000
    lazy var searchController = UISearchController(searchResultsController: resultsViewController)
    let serviceManager = Service()
    var selectedPin : MKPlacemark? = nil
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        let initialLocation = CLLocation(latitude: 49.276557, longitude: -123.119759)
//      slack   49.276557, -123.119759
        return map
    }()
    
    private func setUpSearchController() {
        
        resultsViewController.mapView = mapView
        // Assign searchResultsUpdater delegate to restaurantTable
//        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = MapViewController.SearchPlaceHolder
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        view.addSubview(mapView)
        setUpSearchController()
        setUpViews()

        navigationItem.title = MapViewController.Foodventures
        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        restaurantSearchTable.handleMapSearchDelegate = self
        checkLocationServices()
    }
    
    private func setUpViews() {
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
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please Enable Location Services in Settings->Privacy->Location Services ->On", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            print("Location .denied")
            break
        case .notDetermined:
            print("Location not determined")
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Location .restricted")
            // Active restrictions such as parental control or something
            break
        case .authorizedAlways:
            print("Location authorized Always")
            // HIG says don't use this bad boi
            break
            
        @unknown default:
            fatalError("authorizationStatus case not implemented")
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            print("latitude \(location.latitude) and \(location.longitude)")
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionSpanInMeters, longitudinalMeters: regionSpanInMeters)
        //TODO:  Doesn't pass in coordinates
//        serviceManager.coordinate = location.coordinate
        mapView.setRegion(region, animated: true)
    }
    
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
            resultsViewController.fetchYelpData(searchText: searchText)
        }
        
        searchBar.resignFirstResponder()
        
    }
}

//MARK: - HandelMapSearch
//extension MapViewController : HandleMapSearch {
//    func dropPinZoomIn(placemark: MKPlacemark) {
//        // cache the pin
//        selectedPin = placemark
//        // clear exisiting pins
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        if let city = placemark.locality, let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city) \(state)"
//        }
//        mapView.addAnnotation(annotation)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//}



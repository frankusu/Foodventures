//
//  ViewController.swift
//  Foodventures
//
//  Created by Frank Su on 2019-12-29.
//  Copyright © 2019 frankusu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    //MARK: Properties
    let locationManager = CLLocationManager()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
//        let initialLocation = CLLocation(latitude: 49.246292, longitude: -123.116226)
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
//        map.setRegion(coordinateRegion, animated: true)
        
        return map
    }()
    
//    let searchController : UISearchController = {
//        let search = UISearchController(searchResultsController: nil)
//        return search
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        setUpViews()
        setUpCurrentLocation()
        
    }

    //MARK: Methods
    
    func setUpCurrentLocation() {
        // could take time for requested info to come back, use delegate to handle asynch
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
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

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
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

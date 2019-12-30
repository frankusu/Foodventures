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

    let mapView : MKMapView = {
        let map = MKMapView()
        
        map.translatesAutoresizingMaskIntoConstraints = false
        let initialLocation = CLLocation(latitude: 49.246292, longitude: -123.116226)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
        
        return map
    }()
    
//    let searchController : UISearchController = {
//        let search = UISearchController(searchResultsController: nil)
//        return search
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
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


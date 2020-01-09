//
//  RestaurantSearchTable.swift
//  Foodventures
//
//  Created by Frank Su on 2019-12-30.
//  Copyright © 2019 frankusu. All rights reserved.
//

import UIKit
import MapKit

class RestaurantSearchTable: UITableViewController {

    //MARK: Properties
    
    var matchingItems: [MKMapItem] = []
    // Used for localized search, a handle to the map from previous screen
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate : HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mapItemIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapItemIdentifier", for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        
        cell.detailTextLabel?.text = address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

}
//MARK: - UISearchResultsUpdating

extension RestaurantSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        print("\(searchBarText)")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response,error  in
            guard let response = response else {return}
            self.matchingItems = response.mapItems
            print("search.start")
            self.tableView.reloadData()
        }
    }
}

//
//  ResultsViewController.swift
//  Foodventures
//
//  Created by Frank Su on 2020-01-20.
//  Copyright © 2020 frankusu. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "Cell"

class ResultsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var mapView : MKMapView? = nil
    fileprivate var restaurantResults = [Restaurant]()
    
    func fetchYelpData(searchText: String) {
        Service.shared.fetchYelp(searchText: searchText) { (result, error) in
            if let error = error {
                print("Failed to fetch searched restaurant", error)
            }
            self.restaurantResults = result
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 130)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(ResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white

    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCell
        let restaurantResult = restaurantResults[indexPath.item]
        cell.backgroundColor = .red
        cell.nameLabel.text = restaurantResult.name
        if let categories = restaurantResult.categories {
            cell.aliasLabel.text = categories[0].alias
        } else {
            cell.aliasLabel.text = "Food"
        }
        
        cell.ratingsLabel.text = String(restaurantResult.rating ?? 0)
    
        return cell
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

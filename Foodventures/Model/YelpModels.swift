//
//  YelpModels.swift
//  Foodventures
//
//  Created by Frank Su on 2020-01-08.
//  Copyright © 2020 frankusu. All rights reserved.
//

import Foundation

// For search business results
struct Businesses : Decodable {
    let businesses : [Restaurant]
}

struct Restaurant : Decodable {
    let id: String
    let name: String
    let image_url: String
    let categories : [Categories]?
    let rating: Float?
    let price : String?
//    let location : [String : [String]] dictionary with nested array
    
}



struct Categories : Decodable {
    let alias : String
    let title : String
}



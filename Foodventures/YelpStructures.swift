//
//  YelpStructures.swift
//  Foodventures
//
//  Created by Frank Su on 2020-01-08.
//  Copyright © 2020 frankusu. All rights reserved.
//

import Foundation


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

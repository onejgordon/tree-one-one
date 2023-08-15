//
//  Constants.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 10/4/21.
//

import Foundation
import CoreLocation
import SwiftUI

struct Constants {
    static let APP_NAME = "TreeOneOne"
    
    static let NYC_PARKS_TREE_API_URL = "https://data.cityofnewyork.us/resource/uvpi-gqnh.json"
    static let NYC_PARKS_FOREST_POINTS_API_URL = "https://data.cityofnewyork.us/resource/hn5i-inap.json"
    static let DEFAULT_LOCATION = CLLocation(latitude: 40.7259303, longitude: -73.9939449)
    static let DEFAULT_SEARCH_LATLON_RANGE = 0.0008
    static let N_QUIZ_OPTIONS = 4
    
    static let CORRECT_BG_COLOR = Color.green
    static let INCORRECT_BG_COLOR = Color(red: 0.8, green: 0.8, blue: 0.8)
    
}

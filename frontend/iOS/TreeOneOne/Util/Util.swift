//
//  Util.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 7/2/23.
//

import Foundation
import CoreLocation

func timestamp() -> Int32 {
    return Int32(Date().timeIntervalSince1970)
}

func latLonTruncKey(coord: CLLocationCoordinate2D, decPlaces: Int = 5) -> String {
    // Return a truncated lat/lon key, e.g. "40.7259,-73.9939"
    return String(format: "%.\(decPlaces)f,%.\(decPlaces)f", coord.latitude, coord.longitude)
}

//
//  TreeModel.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import Foundation
import CoreLocation

enum APIDataSource: CaseIterable {
    case treeCensusAPI
    case forestryPointAPI
}


class Tree: ObservableObject, Identifiable {
    var id: Int
    var stump_diameter: Float
    var species_common: String
    var species_latin: String
    var health: String
    var address: String
    let latitude: Double
    let longitude: Double
    let data_source: APIDataSource
    
    init(id: String, stump_diameter: Float, species_common: String, species_latin: String,
         health: String, address: String,
         latitude: Double, longitude: Double, data_source: APIDataSource) {
        self.id = Int(id)!
        self.stump_diameter = stump_diameter
        self.species_common = species_common
        self.species_latin = species_latin
        self.health = health
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.data_source = data_source
    }
    
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distanceFrom(_ loc:CLLocation) -> CLLocationDistance {
        return getLocation().distance(from: loc)
    }
    
    func printCommonName() -> String {
        return species_common.capitalized
    }

}

/* NOTE: Redundant struct inheritance here given limited Swift support */
struct CensusTree: Codable {
    let tree_id: String
    let tree_dbh: String?
    let health: String?
    let stump_diam: String?
    let spc_latin: String?
    let spc_common: String?
    let address: String?
    let latitude: String
    let longitude: String

    func toTree() -> Tree {
        let stump_diameter = stump_diam != nil ? Float(stump_diam!) ?? 0 : 0
        let latitude = Double(latitude) ?? 0
        let longitude = Double(longitude) ?? 0
        return Tree(id: tree_id, stump_diameter: stump_diameter,
                    species_common: spc_common ?? "", species_latin: spc_latin ?? "",
                    health: health ?? "", address: address ?? "",
                    latitude: latitude, longitude: longitude, data_source: .treeCensusAPI)
    }
    
}

struct ForestryLocation: Codable {
    let type: String
    let coordinates: [Float]
}

struct ForestryTree: Codable {
    let objectid: String
    let dbh: String?
    let tpstructure: String?
    let tpcondition: String?
    let genusspecies: String?
    let stumpdiameter: String?
    let location: ForestryLocation

    func toTree() -> Tree {
        let stump_diameter = stumpdiameter != nil ? Float(stumpdiameter!) ?? 0 : 0
        let latitude = Double(location.coordinates[1])
        let longitude = Double(location.coordinates[0])
        var species_common = ""
        var species_latin = ""
        if let genusspecies = genusspecies {
            species_latin = String(genusspecies.split(separator: " - ")[0])
            species_common = String(genusspecies.split(separator: " - ")[1])
        }
        return Tree(id: objectid, stump_diameter: stump_diameter,
                    species_common: species_common, species_latin: species_latin,
                    health: tpcondition ?? "", address: "",
                    latitude: latitude, longitude: longitude, data_source: .forestryPointAPI)
    }
    
}

// Now conform to Identifiable

extension CensusTree: Identifiable {
    var id: Int { return Int(tree_id)! }
}

extension ForestryTree: Identifiable {
    var id: Int { return Int(objectid)! }
}

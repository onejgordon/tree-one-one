//
//  NYDataService.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

class NYDataService: ObservableObject {
    @Published var trees: [Tree] = []
    var treeRedundancyMap: [String : Int] = [String : Int]()
    var isFetching = false
    
    func notYetFetched() -> Bool {
        return !isFetching && self.trees.isEmpty
    }
    
    func findClosestTree(lm:LocationManager) -> Tree? {
        guard let myLocation = lm.lastLocation else {
            return nil
        }
        if (trees.count > 0) {
            return trees.sorted{ $0.distanceFrom(myLocation) < $1.distanceFrom(myLocation) }[0]
        } else {
            return nil;
        }
    }
    
    func fetchNearbyTreesFromAllSources(_ loc:CLLocationCoordinate2D,
            latRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
            lonRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
            maxTrees:Int = 100) {
        let session = URLSession.shared
        
        let parksFetch = fetchNearbyTreesFromCensusData(loc, latRange: latRange, lonRange: lonRange, session: session, maxTrees: maxTrees)
        let forestryFetch = fetchNearbyTreesFromForestryPointsData(loc, latRange: latRange, lonRange: lonRange,
                                                           session: session, maxTrees: maxTrees)
        
        if parksFetch != nil {
            parksFetch!.resume()
        }
        if forestryFetch != nil {
            forestryFetch!.resume()
        }
    }
    
    func socrataURLQuery(source: APIDataSource, whereQuery: String, maxTrees: Int=100) -> URLComponents {
        var baseUrl: String = ""
        switch source {
            case APIDataSource.forestryPointAPI:
                baseUrl = Constants.NYC_PARKS_FOREST_POINTS_API_URL
            case APIDataSource.treeCensusAPI:
                baseUrl = Constants.NYC_PARKS_TREE_API_URL
        }
        let appToken: String = Bundle.main.infoDictionary?["NYC_PARKS_TREE_API_APP_TOKEN"] as! String
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "$$app_token", value: appToken),
            URLQueryItem(name: "$limit", value: String(maxTrees)),
            URLQueryItem(name: "$where", value: whereQuery),
        ]
        return urlComponents
    }
    
    func isRedundant(tree: Tree) -> Bool {
        let key : String = latLonTruncKey(coord: tree.getCoordinate())
        if (treeRedundancyMap.keys.contains(key)) {
            // Skip, too near
            print("Skipping tree with lat/lon key: \(key) -- same as existing")
            return true
        } else {
            treeRedundancyMap[key] = 1
            return false
        }
    }
    
    func fetchNearbyTreesFromCensusData(_ loc:CLLocationCoordinate2D,
                                  latRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
                                  lonRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
                                  session: URLSession,
                                  maxTrees:Int = 100) -> URLSessionDataTask? {

        let lat_0 = loc.latitude - latRange/2
        let lat_1 = loc.latitude + latRange/2
        let lon_0 = loc.longitude - lonRange/2
        let lon_1 = loc.longitude + lonRange/2
        let whereQuery = "latitude between \(lat_0) and \(lat_1) and longitude between \(lon_0) and \(lon_1) and health != \"Dead\""
        print(whereQuery)
        let urlComponents = socrataURLQuery(source: .treeCensusAPI, whereQuery: whereQuery, maxTrees: maxTrees)

        self.isFetching = true;

        print("Fetching from Tree API...")
        return session.dataTask(with: urlComponents.url!) { data, response, error in
            self.isFetching = false

            if let error = error {
                print("Error: \(error.localizedDescription)")
                print(error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decodedTrees = try JSONDecoder().decode([CensusTree].self, from: data)
                print("Fetched \(decodedTrees.count) tree(s) from Census API")
                DispatchQueue.main.async {
                    self.trees.insert(contentsOf: decodedTrees.compactMap({ censusTree in
                        let tree = censusTree.toTree();
                        if (self.isRedundant(tree: tree)) {
                            return nil
                        } else {
                            return tree
                        }
                    }), at: 0)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print(error)
            }
        }
    }
    
    func fetchNearbyTreesFromForestryPointsData(_ loc:CLLocationCoordinate2D,
                          latRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
                          lonRange:Double = Constants.DEFAULT_SEARCH_LATLON_RANGE,
                          session: URLSession,
                          maxTrees:Int = 100) -> URLSessionDataTask? {
        self.isFetching = true;
        let lat_0 = loc.latitude - latRange/2
        let lat_1 = loc.latitude + latRange/2
        let lon_0 = loc.longitude - lonRange/2
        let lon_1 = loc.longitude + lonRange/2
        let whereQuery = "within_box(location, \(lat_0), \(lon_0), \(lat_1), \(lon_1)) AND tpcondition != \"Dead\""
        print(whereQuery)
        let urlComponents = socrataURLQuery(source: .forestryPointAPI, whereQuery: whereQuery, maxTrees: maxTrees)
        
        print("Fetching from Foresty Point API...")
        return session.dataTask(with: urlComponents.url!) { data, response, error in
            self.isFetching = false

            if let error = error {
                print("Error: \(error.localizedDescription)")
                print(error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decodedTrees = try JSONDecoder().decode([ForestryTree].self, from: data)
                print("Fetched \(decodedTrees.count) tree(s) from Forestry Point API")
                DispatchQueue.main.async {
                    self.trees.insert(contentsOf: decodedTrees.compactMap({ fTree in
                        let tree = fTree.toTree();
                        if (self.isRedundant(tree: tree)) {
                            return nil
                        } else {
                            return tree
                        }
                    }), at: 0)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print(error)
            }
        }
    }

}

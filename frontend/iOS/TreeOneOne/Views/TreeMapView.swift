//
//  ContentView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/3/23.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: ObservableObject {
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: Constants.DEFAULT_LOCATION.coordinate,
         span: MKCoordinateSpan(latitudeDelta: Constants.DEFAULT_SEARCH_LATLON_RANGE, longitudeDelta: Constants.DEFAULT_SEARCH_LATLON_RANGE)
    )
    
    func updateRegion(center: CLLocation) {
        coordinateRegion = MKCoordinateRegion(
            center: center.coordinate,
            span: MKCoordinateSpan(latitudeDelta: Constants.DEFAULT_SEARCH_LATLON_RANGE, longitudeDelta: Constants.DEFAULT_SEARCH_LATLON_RANGE)
        )
    }
}

struct TreeMapView: View {
    @StateObject var nycData = NYDataService()
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel: MapViewModel = MapViewModel();
    @State var focusTree : Tree?
    @State var myLocation : CLLocation?
    @State var mapFocusLocation : CLLocation
    @State var quizMode : Bool = UserDefaults.standard.bool(forKey: "quizMode")

    init(loc: CLLocation? = nil) {
        self.myLocation = loc
        if (loc != nil) {
            print(loc?.coordinate ?? "--")
            mapFocusLocation = loc!
        } else {
            mapFocusLocation = Constants.DEFAULT_LOCATION
        }
    }
    
    var focusPopoverVisible: Bool { focusTree != nil }

    func handleLocationChange(location: CLLocation) {
        // TODO: Should we actually check against last query location?
        let significantLocationChange = self.myLocation == nil || location.distance(from: myLocation!) > 50  // meters
        self.myLocation = location
        if (significantLocationChange || nycData.notYetFetched()) {
            fetchTrees()
            moveMap(self.myLocation!)
        }
    }
    
    func fetchTrees() {
        nycData.fetchNearbyTreesFromAllSources(self.myLocation!.coordinate)
    }
        
    func closestTree() {
        if let tree = nycData.findClosestTree(lm: locationManager) {
            handleFocusChange(tree: tree)
        }
    }
    
    func dismissDetail() {
        focusTree = nil
    }
    
    func handleFocusChange(tree: Tree) {
        focusTree = tree
        if (focusTree != nil) {
            print("Focus changed to tree \(tree.id)")
            moveMap(focusTree!.getLocation())
        }
    }
    
    func moveMap(_ loc: CLLocation) {
        mapFocusLocation = loc
        self.viewModel.updateRegion(center: loc)
    }
    
    var body: some View {
        VStack {
            if (focusPopoverVisible) {
                TreeDetailView(tree: focusTree!, quizMode: quizMode)
                Button("Dismiss", action: dismissDetail)
                    .padding()
            } else {
                HStack {
                    Text("Showing \($nycData.trees.count) Nearby Trees")
                    Toggle(isOn: $quizMode) {
                        Text("Quiz Mode")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.onChange(of: quizMode) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "quizMode")
                    }
                }
            }
        }
        .onReceive(locationManager.$lastLocation) { newLocation in
            if let newLocation = newLocation {
                handleLocationChange(location: newLocation)
            }
        }
        .navigationTitle("Nearby Trees")
        .padding()

        MapView(onFocusChange: self.handleFocusChange, viewModel: viewModel, nycData: nycData, focusTreeId: focusTree?.id)
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottomTrailing) {
                Button(action: closestTree) {
                    Text("Closest Tree")
                }
                .font(.title)
                .buttonStyle(.borderedProminent)
                .padding()
            }.onAppear() {
                moveMap(mapFocusLocation)
            }
    }
}

struct NearbyTreesView_Previews: PreviewProvider {
    static var previews: some View {
        TreeMapView(loc: Constants.DEFAULT_LOCATION)
    }
}

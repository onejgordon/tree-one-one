//
//  ContentView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [String] = ["map"]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink("Map", value: "map")
                NavigationLink("About", value: "about")
                NavigationLink("Stats", value: "stats")
                NavigationLink("Settings", value: "settings")
            }.navigationDestination(for: String.self) { key in
                if (key == "map") {
                    TreeMapView()
                } else if (key == "about") {
                    AboutView()
                } else if (key == "stats") {
                    StatsView()
                } else if (key == "settings") {
                    SettingsView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

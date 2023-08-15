//
//  TreeOneOneApp.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/3/23.
//

import SwiftUI

@main
struct TreeOneOneApp: App {
    @StateObject var store = SettingsStore()
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environmentObject(store)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

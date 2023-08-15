//
//  AboutView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import SwiftUI

struct AboutView: View {
    
    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("About")
                .font(.title)
            
            Text("TreeOneOne - An app to help you get to know your neighbors.")
                .font(.body)
                .multilineTextAlignment(.center)

            
            Text("Thanks to the incredible NYC Parks open datasets, TreeOneOne covers most tress across the five boroughs.")
                .font(.body)
                .multilineTextAlignment(.center)

            Link("NYC Parks Open Data Portal", destination: URL(string: "https://www.nycgovparks.org/about/data")!)

            Text("We'd love to hear any suggestions, favorite trees, or reports of bugs. Send a message through the contact page below.")
                .font(.body)
                .multilineTextAlignment(.center)


            Link("Contact Page", destination: URL(string: "https://jgordon.io/contact")!)

            Text("App Version: \(appVersion)")
                .font(.caption)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

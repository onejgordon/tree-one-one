//
//  SettingsView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
                
            Text("Number of Quiz Options")
                .bold()
            Picker(selection: $store.quizOptions, label: Text("Number of Quiz Options"), content: {
                Text("3 Options").tag(QuizOptionCount.three)
                Text("4 Options").tag(QuizOptionCount.four)
                Text("5 Options").tag(QuizOptionCount.five)
            })
            .pickerStyle(.menu)
        }
    }
}


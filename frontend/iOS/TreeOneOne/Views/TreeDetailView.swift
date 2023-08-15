//
//  TreeDetailView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import Foundation
import SwiftUI
import MapKit


enum QuizState {
    case none
    case questions_showing
    case result_showing
}


enum QuizFeedback {
    case none
    case correct
    case incorrect
}


struct TreeDetailView: View {
    private var tree: Tree?
    var quizMode: Bool
    @State private var infoShowing: Bool
    
    init(tree: Tree?, quizMode: Bool) {
        self.tree = tree
        self.quizMode = quizMode
        self.infoShowing = !self.quizMode
    }
    
    func showInfo() {
        self.infoShowing = true
    }
    
    var body: some View {
        if (self.infoShowing) {
            TreeDetailInfoShowing(tree: tree)
        } else if (self.quizMode) {
            TreeDetailQuiz(tree: tree!, responseCallback: {
                self.showInfo()
            })
        }
    }
}

struct TreeDetailInfoShowing: View {
    private var tree: Tree?
    
    init(tree: Tree?) {
        self.tree = tree
        
    }
    
    var body: some View {
        if let tree = self.tree {
            VStack {
                Text(tree.printCommonName())
                    .font(.largeTitle)
                Text("Latin name: \(tree.species_latin)")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .italic()
                Text("Stump Diameter: \(String(format: "%.2f", tree.stump_diameter)) inches")
                    .font(.body)
                Text("Health: \(tree.health)")
                    .font(.body)
                Text("Nearest address: \(tree.address)")
                    .font(.caption)
            }

        }
    }
}

struct TreeDetailQuiz: View {
    private var tree: Tree?
    private var responseCallback: () -> Void
    @State private var quizState: QuizState
    @State private var showFeedback: QuizFeedback = .none
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var store: SettingsStore

    @State private var quizOptions: [String] = []
    
    init(tree: Tree?, responseCallback: @escaping () -> Void) {
        self.tree = tree
        self.quizState = .questions_showing
        self.responseCallback = responseCallback
    }
    
    func buildQuiz() {
        // Generate randomized quiz options (choose species list based on data source)
        var allSpecies: [String] = []
        if (tree?.data_source == .forestryPointAPI) {
            allSpecies = Array(ForestPointTreeSpecies.allCases.map { $0.rawValue })
        } else if (tree?.data_source == .treeCensusAPI) {
            allSpecies = Array(CensusTreeSpecies.allCases.map { $0.rawValue })
        }
        var initialQuizOptions: [String] = []
        if let treeSpecies = self.tree?.printCommonName() {
            initialQuizOptions.append(treeSpecies)
        }
        while (initialQuizOptions.count < store.quizOptions.rawValue) {
            let candidate: String = allSpecies.randomElement()!.capitalized
            if (!initialQuizOptions.contains(candidate)) {
                initialQuizOptions.append(candidate)
            }
        }
        self.quizOptions = initialQuizOptions.shuffled()
    }
    
    func saveQuizResponse(_ correct: Bool) {
        dataController.addResponse(tree: self.tree!, correct: correct, context: moc)
    }
    
    func handleResponse(_ treeSpecies: String) {
        let correct = treeSpecies.lowercased() == self.tree?.species_common.lowercased()
        print("\(treeSpecies) is \(correct ? "Correct" : "Incorrect")")
        // TODO: Show feedback, wait X seconds, then show all info
        self.showFeedback = correct ? .correct : .incorrect
        saveQuizResponse(correct)
        // Transient feedback message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showFeedback = .none
            self.responseCallback()  // Inform parent, show info
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("What species do you think this tree is (it's the one highlighted orange in the map)?")
                    .padding()
                HStack {
                    ForEach(self.quizOptions, id: \.self) { treeSpecies in
                        Button(action: {
                            withAnimation {
                                handleResponse(treeSpecies)
                            }
                        }) {
                            Text(treeSpecies)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .font(.system(size: 12))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            if showFeedback != .none {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(showFeedback == .correct ? Constants.CORRECT_BG_COLOR : Constants.INCORRECT_BG_COLOR)
                    .frame(width: 200, height: 200)
                    .transition(.scaleAndOpacity)
                    .overlay(
                        VStack {
                            Text(showFeedback == .correct ? "Correct!" : "Sorry").font(.title)
                        }
                    )
            }
        }.onAppear {
            buildQuiz()
        }
        
    }
}

extension AnyTransition {
    static var scaleAndOpacity: AnyTransition {
        AnyTransition.scale.combined(with: .opacity)
    }
}

//
//  SettingsStore.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 7/2/23.
//
import Foundation

enum QuizOptionCount: Int {
    case three = 3
    case four = 4
    case five = 5
}

class SettingsStore: ObservableObject {
    let QUIZ_OPTION_KEY = "QuizOptionCount"
    
    @Published var quizOptions: QuizOptionCount {
        didSet {
            UserDefaults.standard.set(quizOptions.rawValue, forKey: QUIZ_OPTION_KEY)
        }
    }

    init() {
        self.quizOptions = (UserDefaults.standard.object(forKey: QUIZ_OPTION_KEY) == nil ? QuizOptionCount.four : QuizOptionCount(rawValue: UserDefaults.standard.object(forKey: QUIZ_OPTION_KEY) as! Int)) ?? QuizOptionCount.four
    }
}

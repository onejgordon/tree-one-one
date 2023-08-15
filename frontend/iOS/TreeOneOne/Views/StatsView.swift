//
//  StatsView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import SwiftUI
import CoreData

struct StatsSummary {
    var n_correct: Int = 0
    var n_total: Int = 0
        
    func printSuccessRate() -> String {
        let percent: Decimal = n_total > 0 ? Decimal(n_correct) / Decimal(n_total) * 100 : 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: percent as NSDecimalNumber) ?? ""
    }
}

struct StatsView: View {
    @EnvironmentObject var dataController: DataController
    @State var stats: StatsSummary?

    func calculateStats() -> StatsSummary {
        var successfulCount: Int = 0
        var allCount: Int = 0
        let context = dataController.container.viewContext
       
        let correctFetchRequest: NSFetchRequest<QuizResponse> = QuizResponse.fetchRequest()
        correctFetchRequest.predicate = NSPredicate(format: "successful == %d", 1)
        let allFetchRequest: NSFetchRequest<QuizResponse> = QuizResponse.fetchRequest()

        do {
            successfulCount = try context.count(for: correctFetchRequest)
            allCount = try context.count(for: allFetchRequest)
        } catch {
            print (error)
        }
        return StatsSummary(n_correct: successfulCount, n_total: allCount)
    }
    
    var body: some View {
        Text("Quiz Stats")
            .font(.title)
        List {
            Text("Responses: \(stats?.n_total ?? 0)")
            Text("Success Rate: \(stats?.printSuccessRate() ?? "0")%")
        }.onAppear {
            self.stats = calculateStats()
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(stats: StatsSummary())
    }
}

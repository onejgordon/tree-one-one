//
//  DateController.swift
//  MyLandmarks
//
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataModel")
    @Published var responses: [QuizResponse] = []
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        fetchResponses()
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            fetchResponses()
            print("Data saved")
        } catch {
            print("Data could not be saved...")
        }
    }
    
    func fetchResponses() {
        let request = NSFetchRequest<QuizResponse>(entityName: "QuizResponse")
        
        do {
            responses = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addResponse(tree: Tree, correct: Bool, context: NSManagedObjectContext) {
        let response = QuizResponse(context: context)
        response.tree_id = String(tree.id)
        response.n_guesses = 1
        response.successful = correct ? 1 : 0
        response.timestamp = timestamp()
        save(context: context)
    }
    
    func editResponse(response: QuizResponse, context: NSManagedObjectContext) {
        response.tree_id = response.tree_id
        response.n_guesses = response.n_guesses
        response.successful = response.successful
        save(context: context)
    }
    
    func deleteResponse(response: QuizResponse, context: NSManagedObjectContext) {
        context.delete(response)
        save(context: context)
    }
    
}

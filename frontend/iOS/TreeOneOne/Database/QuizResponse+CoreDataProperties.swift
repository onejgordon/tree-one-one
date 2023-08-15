//
//  QuizResponse+CoreDataProperties.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 7/1/23.
//
//

import Foundation
import CoreData


extension QuizResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizResponse> {
        return NSFetchRequest<QuizResponse>(entityName: "QuizResponse")
    }

    @NSManaged public var tree_id: String
    @NSManaged public var n_guesses: Int16
    @NSManaged public var successful: Int16
    @NSManaged public var timestamp: Int32

}

extension QuizResponse : Identifiable {

}

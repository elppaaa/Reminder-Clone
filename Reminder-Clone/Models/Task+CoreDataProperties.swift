//
//  Task+CoreDataProperties.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/18.
//
//

import Foundation
import CoreData
import UIKit

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var flag: Bool
    @NSManaged public var image: [UIImage]?
    @NSManaged public var isDone: Bool
    @NSManaged public var link: String?
    @NSManaged public var location: Data?
    @NSManaged public var notes: String?
    @NSManaged public var priority: Int16
    @NSManaged public var time: Date?
    @NSManaged public var title: String
    @NSManaged public var category: Category
    @NSManaged public var parent: Task?
    @NSManaged public var subtasks: NSSet?

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Task)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Task)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

extension Task: Identifiable {

}

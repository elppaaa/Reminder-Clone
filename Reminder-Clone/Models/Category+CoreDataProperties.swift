//
//  Category+CoreDataProperties.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/15.
//
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var colorInt: Int32
    @NSManaged public var iconString: String?
    @NSManaged public var name: String
    @NSManaged public var order: NSDecimalNumber?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Category {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Category: Identifiable {

}

//
//  Task+CoreDataProperties.swift
//  Reminder-Clone
//
//  Created by JK on 2021/06/03.
//
//

import Foundation
import CoreData
import UIKit

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var createdDate: Date
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
    @NSManaged public var subtasks: NSOrderedSet?

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(insertObject:inSubtasksAtIndex:)
    @NSManaged public func insertIntoSubtasks(_ value: Task, at idx: Int)

    @objc(removeObjectFromSubtasksAtIndex:)
    @NSManaged public func removeFromSubtasks(at idx: Int)

    @objc(insertSubtasks:atIndexes:)
    @NSManaged public func insertIntoSubtasks(_ values: [Task], at indexes: NSIndexSet)

    @objc(removeSubtasksAtIndexes:)
    @NSManaged public func removeFromSubtasks(at indexes: NSIndexSet)

    @objc(replaceObjectInSubtasksAtIndex:withObject:)
    @NSManaged public func replaceSubtasks(at idx: Int, with value: Task)

    @objc(replaceSubtasksAtIndexes:withSubtasks:)
    @NSManaged public func replaceSubtasks(at indexes: NSIndexSet, with values: [Task])

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Task)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Task)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSOrderedSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSOrderedSet)

}

extension Task: Identifiable {

}

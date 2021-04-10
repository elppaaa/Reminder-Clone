//
//  Task+CoreDataClass.swift
//  Reminder-Clone
//
//  Created by JK on 2021/04/15.
//
//

import UIKit
import CoreData

enum TaskAttributesKey: String {
	case title = "title"
	case notes = "notes"
	case URL = "link"
	case date = "date"
	case time = "time"
	case location = "location"
	case flag = "flag"
	case priority = "priority"
	case image = "image"
	case subtasks = "children"
	case parent = "list"
}

@objc(Task)
public class Task: NSManagedObject {
	var dictionary: [TaskAttributesKey: Any] {
		var dict = [TaskAttributesKey: Any]()
		dict[.title] = title
		dict[.notes] = notes
		dict[.URL] = link
		dict[.date] = date
		dict[.time] = time
		dict[.location] = location
		dict[.flag] = flag
		dict[.image] = location
		dict[.parent] = parent
		dict[.subtasks] = children
		return dict
	}
}

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
	case title
	case notes
	case URL = "link"
	case date
	case time
	case location
	case flag
	case priority
	case image
	case subtasks
	case parent
  case category
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
		dict[.image] = image
		dict[.parent] = parent
    dict[.category] = category
    dict[.subtasks] = subtasks
		return dict
	}
}

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
  case isDone
}

@objc (Task)
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
    dict[.isDone] = isDone
    return dict
  }

  func get(_ key: TaskAttributesKey) -> Any? {
    switch key {
    case .title:
      return title
    case .notes:
      return notes
    case .URL:
      return link
    case .date:
      return notes
    case .time:
      return time
    case .location:
      return location
    case .flag:
      return flag
    case .priority:
      return priority
    case .image:
      return image
    case .parent:
      return parent
    case .category:
      return category
    case .subtasks:
      return subtasks
    case .isDone:
      return isDone
    }
  }

  func set(key: TaskAttributesKey, value: Any?) {
    self.setValue(value, forKey: key.rawValue)
  }

  func set(dict: [TaskAttributesKey: Any]) {
    for (k, v) in dict {
      setValue(v, forKey: k.rawValue)
    }
  }
  
}

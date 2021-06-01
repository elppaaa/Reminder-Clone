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
  case createdDate

}

@objc (Task)
public class Task: NSManagedObject {
  func get(_ key: TaskAttributesKey) -> Any? {
    switch key {
    case .title:
      return title
    case .notes:
      return notes
    case .URL:
      return link
    case .date:
      return date
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
    case .createdDate:
      return createdDate
    }
  }

  func set<T>(key: TaskAttributesKey, value: T) {
    self.setValue(value, forKey: key.rawValue)
  }

  func set(dict: [TaskAttributesKey: Any]) {
    for (k, v) in dict {
      setValue(v, forKey: k.rawValue)
    }
  }

}

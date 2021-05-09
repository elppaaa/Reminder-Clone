//
//  Category+CoreDataClass.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//
//

import Foundation
import CoreData

enum CategoryAttributeKey: String {
  case color
  case icon
  case name
  case order
  case tasks
}

@objc (Category)
public class Category: NSManagedObject {
  var dictionary: [CategoryAttributeKey: Any] {
    var dict = [CategoryAttributeKey: Any]()
    dict[.name] = name
    dict[.icon] = icon
    dict[.color] = color
    dict[.order] = order
    dict[.tasks] = tasks
    return dict
  }

  func set<T>(key: CategoryAttributeKey, value: T) {
    self.setValue(value, forKey: key.rawValue)
  }

  func set(dict: [CategoryAttributeKey: Any]) {
    for (k, v) in dict {
      setValue(v, forKey: k.rawValue)
    }
  }
}

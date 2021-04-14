//
//  Category+CoreDataClass.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//
//

import Foundation
import CoreData

enum CategoryKey: String {
  case color
  case icon
  case name
  case order
  case tasks
}

@objc(Cateogry)
public class Category: NSManagedObject {
  var dictionary: [CategoryKey: Any] {
    var dict = [CategoryKey: Any]()
    dict[.name] = name
    dict[.icon] = icon
    dict[.color] = color
    dict[.order] = order
    dict[.tasks] = tasks
    return dict
  }
}

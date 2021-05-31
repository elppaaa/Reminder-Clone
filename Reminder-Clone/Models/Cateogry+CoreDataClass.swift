//
//  Category+CoreDataClass.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//
//

import Foundation
import CoreData
import UIKit.UIImage
import UIKit.UIColor

enum CategoryAttributeKey: String {
  case color = "colorInt"
  case icon = "iconString"
  case name
  case order
  case tasks
  case isShownCompleted
}

@objc (Category)
public class Category: NSManagedObject {
  var dictionary: [CategoryAttributeKey: Any] {
    var dict = [CategoryAttributeKey: Any]()
    dict[.name] = name
    dict[.icon] = iconString
    dict[.color] = colorInt
    dict[.order] = order
    dict[.tasks] = tasks
    dict[.isShownCompleted] = isShownCompleted
    return dict
  }

  var icon: UIImage? {
    UIImage(systemName: iconString ?? R.Image.listBullet.rawValue)
  }

  var color: UIColor {
    get { UIColor(hex: Int(colorInt)) }
    set { colorInt = Int32(newValue.hex) }
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

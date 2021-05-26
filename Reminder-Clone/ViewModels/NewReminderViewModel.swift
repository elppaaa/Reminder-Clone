//
//  NewReminderViewModel.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/26.
//

import Foundation

class NewReminderViewModel: NSObject {
  var task: Task
  fileprivate let manager = PersistentManager.shared

  override init() {
    self.task = manager.newEntity(entity: Task.self)
    super.init()

    let category = HomeListTableViewModel.shared.data[0] // set default category
    category.addToTasks(task)
  }

  deinit {
    manager.saveContext()
  }

  func set<T: Comparable>(key: TaskAttributesKey, value newValue: T) {
    if let oldValue = task.get(key) as? T?, oldValue != newValue {
      task.set(key: key, value: newValue)
    }
  }

  func setNil(_ key: TaskAttributesKey) {
    task.setValue(nil, forKey: key.rawValue)
  }
  
  var category: Category { task.category ?? HomeListTableViewModel.shared.data[0] }

  func cancel() {
    manager.delete(task)
  }
}

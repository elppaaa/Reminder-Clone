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
    let category = HomeListTableViewModel.shared.data[0] // set default category
    task.set(key: .title, value: "")
    task.set(key: .category, value: category)
    manager.saveContext()
    super.init()
  }

  func set<T: Comparable>(key: TaskAttributesKey, value newValue: T) {
    if let oldValue = task.get(key) as? T?, oldValue != newValue {
      task.set(key: key, value: newValue)
    }
  }

  func createDetailViewModel() -> DetailReminderViewModel {
    DetailReminderViewModel(task: task)
  }

  func setNil(_ key: TaskAttributesKey) {
    task.setValue(nil, forKey: key.rawValue)
  }
  
  var category: Category { task.category }

  func save() {
    NotificationCenter.default.post(name: .CategoryChanged, object: nil)
    manager.saveContext()
  }

  func cancel() {
    DispatchQueue.global().async { [weak self] in
      if let task = self?.task {
        self?.manager.deleteAndSave(task)
      }
    }
  }

}

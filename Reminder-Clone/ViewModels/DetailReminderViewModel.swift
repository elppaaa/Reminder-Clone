//
// Created by JK on 2021/03/19.
//

import UIKit

class DetailReminderViewModel: NSObject {
  var task: Task
  fileprivate let prevCategory: Category
  fileprivate let manager = PersistentManager.shared

  func dateText(_ key: TaskAttributesKey) -> String? {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.locale = Locale.current
    formatter.doesRelativeDateFormatting = true

    switch key {
    case .date:
      guard let value = task.date else { return nil }
      formatter.dateStyle = .full
      return formatter.string(from: value)
    case .time:
      guard let value = task.time else { return nil }
      formatter.timeStyle = .short
      return formatter.string(from: value)
    default:
      return nil
    }
  }

  init(task: Task) {
    manager.saveContext()
    manager.setUndoManager()
    self.task = task
    prevCategory = task.category
    super.init()
  }

  convenience init(_ newTask: Bool = true) {
    let entity = PersistentManager.shared.newTask()
    let category = HomeListTableViewModel.shared.data[0] // need to set default

    entity.set(key: .category, value: category)
    self.init(task: entity)
  }

  deinit {
    unsetUndoManager()
  }

  var priority: Int16 { task.priority }
  var category: Category { task.category }
  var categoryList: [Category] { HomeListTableViewModel.shared.data }

  func unsetUndoManager() {
    manager.unsetUndoManager()
  }
  
  func save() {
    manager.saveContext()
    NotificationCenter.default.post(name: .TaskChanged, object: task)
    if prevCategory != category {
      NotificationCenter.default.post(name: .CategoryChanged, object: prevCategory)
    }
  }

  func rollBack() {
    manager.rollBack()
  }

  func set<T: Comparable>(key: TaskAttributesKey, value newValue: T) {
    if let oldValue = task.get(key) as? T?, oldValue != newValue {
      task.set(key: key, value: newValue)
    }
  }

  func setCategory(value: Category) {
    task.set(key: .category, value: value)
  }

  func setNil(_ key: TaskAttributesKey) {
    task.setValue(nil, forKey: key.rawValue)
  }
}

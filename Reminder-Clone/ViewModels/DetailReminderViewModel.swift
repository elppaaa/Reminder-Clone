//
// Created by JK on 2021/03/19.
//

import UIKit

class DetailReminderViewModel: NSObject {
  @Published var task: Task 
  let manager = PersistentManager.shared

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
    super.init()
  }

  deinit {
    unsetUndoManager()
  }

  var priority: Int16 { task.priority }
  var category: Category { task.category }

  func unsetUndoManager() {
    manager.unsetUndoManager()
  }
  
  func save() {
    manager.saveContext()
  }

  func rollBack() {
    manager.rollBack()
  }
  
  func set<T: Comparable>(key: TaskAttributesKey, value newValue: T) {
    if let oldValue = task.get(key) as? T?, oldValue != newValue {
      NotificationCenter.default.post(name: .TaskChanged, object: task)
      task.set(key: key, value: newValue)
    }
  }

  func setNil(_ key: TaskAttributesKey) {
    NotificationCenter.default.post(name: .TaskChanged, object: task)
    task.setValue(nil, forKey: key.rawValue)
  }

}

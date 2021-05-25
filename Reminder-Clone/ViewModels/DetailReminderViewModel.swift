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
    switch key {
    case .date:
      guard let value = task.date else { return nil }
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.string(from: value)
    case .time:
      guard let value = task.time else { return nil }
      formatter.dateFormat = "HH:mm"
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

  var priority: Int16 {
    get { task.priority }
    set { task.set(key: .priority, value: newValue) }
  }

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
      task.set(key: key, value: newValue)
    }
  }

  func setNil(_ key: TaskAttributesKey) {
    task.setNilValueForKey(key.rawValue)
  }

}

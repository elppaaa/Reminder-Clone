//
// Created by JK on 2021/03/19.
//

import UIKit

class DetailReminderViewModel: NSObject {
  @Published var task: Task
  let manager = PersistentManager.shared

  init(task: Task) {
    manager.saveContext()
    manager.setUndoManager()
    self.task = task
    super.init()
  }
  
  deinit {
    unsetUndoManager()
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

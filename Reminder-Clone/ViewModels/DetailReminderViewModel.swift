//
// Created by JK on 2021/03/19.
//

import UIKit

protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
  func setValue<T>(key: TaskAttributesKey, value: T);
}

class DetailReminderViewModel: NSObject {
  @Published var task: Task 

  var _tableView: UITableView?
  let manager = PersistentManager.shared

  init(task: Task) {
    manager.saveContext()
    manager.setUndoManager()
    self.task = task
    super.init()
  }

  deinit {
    manager.unsetUndoManager()
  }

  func save() {
    manager.saveContext()
  }

  func rollBack() {
    manager.rollBack()
  }

}

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  func setValue<T>(key: TaskAttributesKey, value: T) {
    task.set(key: key, value: value)
  }

  var tableView: UITableView? {
    _tableView
  }
}

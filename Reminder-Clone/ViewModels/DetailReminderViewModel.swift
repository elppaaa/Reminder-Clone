//
// Created by JK on 2021/03/19.
//

import UIKit

protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
  func setValue<T>(key: TaskAttributesKey, value: T);
}

class DetailReminderViewModel: NSObject {
  var task: Task
  var _tableView: UITableView?
  var delegateVC: ViewControllerDelegate?

  init(task: Task) {
    self.task = task
    super.init()
  }

  func save() {
    PersistentManager.shared.saveContext()
  }

  func cancel() {
    PersistentManager.shared.rollBack()
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

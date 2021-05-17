//
// Created by JK on 2021/03/19.
//

import UIKit

protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
  func setValue<T>(key: TaskAttributesKey, value: T);
}

class DetailReminderViewModel: NSObject {
  var _tableView: UITableView?
  var delegateVC: ViewControllerDelegate?
  var dict = [TaskAttributesKey: Any]()
  
}

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  func setValue<T>(key: TaskAttributesKey, value: T) {
    dict[key] = value
  }
  
  var tableView: UITableView? {
    _tableView
  }
}

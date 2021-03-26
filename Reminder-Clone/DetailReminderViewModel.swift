//
// Created by JK on 2021/03/19.
//

import UIKit

@objc protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
}

class DetailReminderViewModel: NSObject {
  var _tableView: UITableView?
  
}

extension DetailReminderViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 4
    case 2:
      return 1
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableViewCellSelector(indexPath: indexPath)
  }

}

extension DetailReminderViewModel: UITableViewDelegate { }

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  var tableView: UITableView? { _tableView }
}

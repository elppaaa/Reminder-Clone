//
// Created by JK on 2021/04/28.
//

import UIKit

class DetailReminderListViewController: UITableViewController {
  fileprivate let viewModel = HomeListTableViewModel.shared

  convenience init() {
    self.init(style: .plain)
    tableView.rowHeight = 55
    tableView.register(DetailReminderListViewCell.self, forCellReuseIdentifier: DetailReminderListViewCell.identifier)
    tableView.tableFooterView = UIView()
  }

  var currentTask: Task?

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    55
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderListViewCell.identifier)
      as? DetailReminderListViewCell else { return UITableViewCell() }
    let category = viewModel.data[indexPath.row]

    cell.icon.setImage(category.icon)
    cell.icon.setBackground(category.color)
    cell.text.text = category.name

    cell.accessoryType = category.objectID == currentTask?.category.objectID ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let task = currentTask {
      viewModel.changeCategory(task: task, category: viewModel.data[indexPath.row])
    } 
    navigationController?.popViewController(animated: true)
  }

}

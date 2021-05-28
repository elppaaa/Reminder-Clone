//
// Created by JK on 2021/04/28.
//

import UIKit

class DetailReminderListViewController: UITableViewController {
  fileprivate var viewModel: DetailReminderViewModel?

  convenience init(with viewModel: DetailReminderViewModel) {
    self.init(style: .plain)
    self.viewModel = viewModel
    tableView.rowHeight = 55
    tableView.register(DetailReminderListViewCell.self, forCellReuseIdentifier: DetailReminderListViewCell.identifier)
    tableView.tableFooterView = UIView()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    55
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel?.categoryList.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderListViewCell.identifier)
      as? DetailReminderListViewCell else { return UITableViewCell() }
    guard let category = viewModel?.categoryList[indexPath.row] else { return UITableViewCell() }

    cell.icon.setImage(category.icon)
    cell.icon.setBackground(category.color)
    cell.text.text = category.name

    cell.accessoryType = category.objectID == viewModel?.task.category.objectID ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel else { return }

    viewModel.setCategory(value: viewModel.categoryList[indexPath.row])
    navigationController?.popViewController(animated: true)
  }

}

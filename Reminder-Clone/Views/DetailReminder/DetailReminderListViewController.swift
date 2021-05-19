//
// Created by JK on 2021/04/28.
//

import UIKit

class DetailReminderListViewController: UITableViewController {
  fileprivate let viewModel = HomeListTableViewModel.shared

  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.rowHeight = 55
    tableView.register(DetailReminderListViewCell.self, forCellReuseIdentifier: DetailReminderListViewCell.identifier)
    tableView.tableFooterView = UIView()
  }

  deinit {
    completionHandler?()
  }

  var currentCategory: Category?
  var currentTask: Task?

  var completionHandler: (() -> Void)?

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

    cell.accessoryType = category.objectID == currentCategory?.objectID ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let task = currentTask {
      viewModel.changeCategory(task: task, category: viewModel.data[indexPath.row])
    }
    navigationController?.popViewController(animated: true)
  }

}

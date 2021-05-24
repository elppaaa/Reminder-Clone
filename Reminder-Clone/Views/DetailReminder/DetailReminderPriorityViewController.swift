//
// Created by JK on 2021/04/24.
//

import UIKit

enum TaskPriority: Int16 {
  case none
  case low
  case medium
  case high

  var text: String {
    switch self {
    case .none:
      return "None"
    case .low:
      return "Low"
    case .medium:
      return "Medium"
    case .high:
      return "Hight"
    }
  }

}

class DetailReminderPriorityViewController: UITableViewController {
  let options: [TaskPriority] = [.none, .low, .medium, .high]

  var completionHandler: (() -> Void)?
  var viewModel: DetailReminderViewModel
  
  required init?(coder: NSCoder) { fatalError("Do not use this initailizer") }
  init(viewModel: DetailReminderViewModel, style: UITableView.Style = .insetGrouped) {
    self.viewModel = viewModel
    super.init(style: style)
  }

  override func viewDidDisappear(_ animated: Bool) {
    completionHandler?()
    super.viewDidDisappear(true)
  }
}

extension DetailReminderPriorityViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if indexPath.row == 0 { cell.separatorInset = .zero }
    cell.textLabel?.text = options[indexPath.row].text
    cell.accessoryType = indexPath.row == viewModel.priority ? .checkmark : .none
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    options.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.performBatchUpdates {
      tableView.cellForRow(at: IndexPath(row: Int(viewModel.priority), section: 0))?.accessoryType = .none
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    viewModel.priority = Int16(indexPath.row)
  }
}

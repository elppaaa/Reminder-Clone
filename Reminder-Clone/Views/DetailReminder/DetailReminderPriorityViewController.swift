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

  var completionHandler: ((Int16) -> Void)?
  var currentPriority: Int16 = 0
  
  required init?(coder: NSCoder) { fatalError("Do not use this initailizer") }
  
  override init(style: UITableView.Style) {
    super.init(style: style)
  }

  override func viewDidDisappear(_ animated: Bool) {
    completionHandler?(currentPriority)
    super.viewDidDisappear(true)
  }
}

extension DetailReminderPriorityViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if indexPath.row == 0 { cell.separatorInset = .zero }
    cell.textLabel?.text = options[indexPath.row].text
    cell.accessoryType = indexPath.row == currentPriority ? .checkmark : .none
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    options.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.performBatchUpdates {
      tableView.cellForRow(at: IndexPath(row: Int(currentPriority), section: 0))?.accessoryType = .none
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    currentPriority = Int16(indexPath.row)
  }
}

//
// Created by JK on 2021/04/24.
//

import UIKit

enum TaskPriority: String {
  case high = "High"
  case medium = "Medium"
  case low = "Low"
  case none = "None"
}

class DetailReminderPriorityViewController: UITableViewController {
  let options: [TaskPriority] = [.none, .low, .medium, .high]
  var selectionIndex = IndexPath(row: 0, section: 0)
  
  required init?(coder: NSCoder) { fatalError("Do not use this initailizer") }
  
  override init(style: UITableView.Style) {
    super.init(style: style)
  }
}

extension DetailReminderPriorityViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if indexPath.row == 0 { cell.separatorInset = .zero }
    cell.textLabel?.text = options[indexPath.row].rawValue
    cell.accessoryType = indexPath == selectionIndex ? .checkmark : .none
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    options.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    tableView.cellForRow(at: selectionIndex)?.accessoryType = .none
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    tableView.endUpdates()
    selectionIndex = indexPath
  }
}

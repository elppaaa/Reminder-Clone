//
// Created by JK on 2021/04/28.
//

import UIKit

class DetailReminderListViewController: UITableViewController {
  var list: [HomeRadiusList] = [
    .init(title: "School", icon: .calendar, color: .systemBlue, count: 4),
    .init(title: "List", icon: .calendar, color: .systemOrange, count: 4),
    .init(title: "Home", icon: .calendar, color: .systemPink, count: 4),
    .init(title: "Test", icon: .calendar, color: .systemYellow, count: 4),
  ]
  
  var selectedIndex = 0
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let data = list[indexPath.row]
    cell.textLabel?.text = data.title
    cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
    tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.accessoryType = .checkmark
    tableView.endUpdates()
    selectedIndex = indexPath.row
    navigationController?.popViewController(animated: true)
  }
  
}

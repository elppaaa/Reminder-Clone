//
// Created by JK on 2021/04/28.
//

import UIKit

class DetailReminderListViewController: UITableViewController {
  var list: [HomeRadiusList] = [
    .init(title: "School", icon: .calenderCircle, color: .systemBlue, count: 4),
    .init(title: "Home", icon: .folderCircle, color: .systemPink, count: 4),
    .init(title: "Test", icon: .flagCircle, color: .systemYellow, count: 4),
    .init(title: "List", icon: .calenderCircle, color: .systemOrange, count: 4),
  ]
  
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.rowHeight = 55
    tableView.register(DetailReminderListViewCell.self, forCellReuseIdentifier: DetailReminderListViewCell.identifier)
    tableView.tableFooterView = UIView()
  }
  
  var selectedIndex = 0
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    55
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderListViewCell.identifier)
      as? DetailReminderListViewCell else { return UITableViewCell() }
    let data = list[indexPath.row]
//    tableView.beginUpdates()
    cell.config(data: data)
//    tableView.endUpdates()
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


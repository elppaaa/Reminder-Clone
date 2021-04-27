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
    cell.detailTextLabel?.text = String(data.count)
    return cell
  }
}

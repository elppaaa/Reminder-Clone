//
// Created by JK on 2021/05/02.
//

import UIKit

class DetailReminderSubtasksViewController: UITableViewController {
  var data = ["AAA", "BBB", "CCC"]
  
  override func loadView() {
    super.loadView()
    tableView.register(DetailReminderSubtaskCell.self, forCellReuseIdentifier: DetailReminderSubtaskCell.identifier)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count + 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == data.count {
      let cell = UITableViewCell()
      cell.imageView?.image = UIImage()
      cell.indentationLevel = 4
      cell.textLabel?.text = "Add Reminder"
      cell.textLabel?.textColor = .systemBlue
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderSubtaskCell.identifier)
      as? DetailReminderSubtaskCell else { return UITableViewCell() }
    cell.delegate = self
    cell.imageView?.image = R.Image.emptyCircle.image
    cell.textView.text = data[indexPath.row]
    return cell
  }
}

extension DetailReminderSubtasksViewController: DetailReminderSubtaskCellDelegate {
  func updateCell() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
}

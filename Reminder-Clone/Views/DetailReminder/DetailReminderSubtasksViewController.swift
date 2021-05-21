//
// Created by JK on 2021/05/02.
//

import UIKit
import CoreData
import Combine

class DetailReminderSubtasksViewController: UITableViewController {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  init(task: Task, style: UITableView.Style = .grouped) {
    viewModel = DetailReminderSubtasksViewModel(parent: task)
    super.init(style: style)
  }
  
  fileprivate let viewModel: DetailReminderSubtasksViewModel
  
  override func loadView() {
    super.loadView()
    tableView.register(DetailReminderSubtaskCell.self, forCellReuseIdentifier: DetailReminderSubtaskCell.identifier)
  }
}

// MARK: - data Source
extension DetailReminderSubtasksViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.count + 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == viewModel.count {
      let cell = UITableViewCell()
      cell.imageView?.image = UIImage()
      cell.indentationLevel = 5
      cell.textLabel?.text = "Add Reminder"
      cell.textLabel?.textColor = .systemBlue
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderSubtaskCell.identifier)
      as? DetailReminderSubtaskCell else { return UITableViewCell() }
    let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .light, scale: .medium)
    cell.imageView?.image = R.Image.emptyCircle.image.withConfiguration(config)
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

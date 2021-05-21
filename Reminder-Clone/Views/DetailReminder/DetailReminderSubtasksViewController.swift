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
      cell.indentationLevel = 4
      cell.textLabel?.text = "Add Reminder"
      cell.textLabel?.textColor = .systemBlue
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderSubtaskCell.identifier)
      as? DetailReminderSubtaskCell else { return UITableViewCell() }
    let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .light, scale: .medium)
    
    let data = viewModel[indexPath.row]
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.textPublisher
        .sink { data.set(key: .title, value: $0) }
    )
    
    cell.imageView?.image = R.Image.emptyCircle.image.withConfiguration(config)
    cell.textView.text = viewModel[indexPath.row].title
    return cell
  }
  
}

extension DetailReminderSubtasksViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if viewModel.isLastEmpty { return }
    
    if indexPath.row == viewModel.count {
      _ = viewModel.newTask(index: indexPath.row)
      tableView.performBatchUpdates {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
      if let cell = tableView.cellForRow(at: indexPath) as? DetailReminderSubtaskCell {
        cell.textView.becomeFirstResponder()
      }
    }
  }
  
  public override func tableView(_ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
      self?.viewModel.delete(index: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      completion(true)
    }
  
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

extension DetailReminderSubtasksViewController: DetailReminderSubtaskCellDelegate {
  func updateCell() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
}

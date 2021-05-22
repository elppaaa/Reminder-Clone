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
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
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
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier)
      as? ReminderTableViewCell else { return UITableViewCell() }
  
    cell.color = viewModel.color
    let data = viewModel[indexPath.row]
    cell.textView.text = data.title
    cell.isDone = data.isDone
    cell.flagVisible = data.flag
    cell.row = indexPath.row
    
    cell.delegate = self
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.textPublisher
        .receive(on: DispatchQueue.global(qos: .userInitiated))
        .removeDuplicates()
        .sink { data.set(key: .title, value: $0) }
    )
  
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.$isDone
        .receive(on: DispatchQueue.global(qos: .userInitiated))
        .removeDuplicates()
        .sink { data.set(key: .isDone, value: $0) }
    )
    
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
      if let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell {
        cell.textView.becomeFirstResponder()
      }
    }
  }
  
  public override func tableView(_ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if indexPath.row == viewModel.count { return nil }
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
      self?.viewModel.delete(index: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      completion(true)
    }
  
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

extension DetailReminderSubtasksViewController: ReminderTableViewCellDelegate {
  func updateCellLayout(_ handler: (() -> Void)? = nil) {
    tableView.performBatchUpdates { handler?() }
  }
  
  func insertTask(index: Int, animate: UITableView.RowAnimation) {
    if viewModel[index].title == "" {
      if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ReminderTableViewCell {
        cell.textView.endEditing(true)
      }
      return
    }
  
    _ = viewModel.newTask(index: index + 1)
    let index = IndexPath(row: index + 1, section: 0)
    tableView.insertRows(at: [index], with: animate)
    if let cell = tableView.cellForRow(at: index) as? ReminderTableViewCell {
      cell.textView.becomeFirstResponder()
    }
  
  }
  
  func removeCell(index: Int) {
    viewModel.delete(index: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
  }
}

//
//  RemindersViewController+ReminderTableViewCellDelegate.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/21.
//

import UIKit

protocol ReminderTableViewCellDelegate {
  func updateCellLayout(_ handler: (() -> Void)?)
  func insertTask(index: Int, animate: UITableView.RowAnimation)
  func removeCell(index: Int)
}

extension RemindersViewController: ReminderTableViewCellDelegate {
  func updateCellLayout(_ handler: (() -> Void)? = nil) {
    tableView.performBatchUpdates {
      handler?()
    }
  }

  func insertTask(index: Int, animate: UITableView.RowAnimation = .fade) {
    if viewModel.tasks.indices.contains(index), viewModel.tasks[index].title == "",
       let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ReminderTableViewCell {
      cell.textView.endEditing(true)
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

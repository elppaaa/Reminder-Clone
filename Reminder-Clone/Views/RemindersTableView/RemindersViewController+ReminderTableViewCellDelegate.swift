//
//  RemindersViewController+ReminderTableViewCellDelegate.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/21.
//

import UIKit
import CoreData.NSManagedObjectID

protocol ReminderTableViewCellDelegate {
  func updateCellLayout(_ handler: (() -> Void)?)
  func insertTask(id objectID: NSManagedObjectID, animate: UITableView.RowAnimation)
  func removeCell(id objectID: NSManagedObjectID)
}

extension RemindersViewController: ReminderTableViewCellDelegate {
  func updateCellLayout(_ handler: (() -> Void)? = nil) {
    tableView.performBatchUpdates {
      handler?()
    }
  }

  func insertTask(id objectID: NSManagedObjectID, animate: UITableView.RowAnimation) {
    guard let _index = viewModel.index(of: objectID) else { return }

    insertTask(index: _index + 1, animate: animate)
  }

  func insertTask(index: Int, animate: UITableView.RowAnimation) {
    viewModel.newTask(index: index) { [weak self] in
      let index = IndexPath(row: index, section: 0)
      self?.tableView.insertRows(at: [index], with: animate)
      if let cell = self?.tableView.cellForRow(at: index) as? ReminderTableViewCell {
        cell.textView.becomeFirstResponder()
      }
    }
  }

  func removeCell(id objectID: NSManagedObjectID) {
    viewModel.delete(id: objectID) { [weak self] index in
      self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
  }
  
}

extension RemindersViewController {
  func hideCell(id objectID: NSManagedObjectID) {
    if viewModel.category.isShownCompleted { return }
    viewModel.hide(id: objectID) { [weak self] index in
      self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
  }
}

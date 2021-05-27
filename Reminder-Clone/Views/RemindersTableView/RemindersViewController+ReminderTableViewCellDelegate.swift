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

    _ = viewModel.newTask(index: _index + 1)
    let index = IndexPath(row: _index + 1, section: 0)
    tableView.insertRows(at: [index], with: animate)
    DispatchQueue.main.async { [weak self] in
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

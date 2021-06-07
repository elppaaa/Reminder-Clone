//
// Created by JK on 2021/05/13.
//

import UIKit

// MARK: - TableView DataSource
extension MainViewController {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "My Lists"
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListTableViewCell.identifier, for: indexPath)
      as? MainListTableViewCell else { fatalError("ERROR WHEN CREATE CELL") }
    let data = viewModel.data[indexPath.row]
    
    tableView.performBatchUpdates {
      cell.config(with: data)
    }
    
    return cell
  }
}

// MARK: - TableView Delegate
extension MainViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    defer { tableView.deselectRow(at: indexPath, animated: true) }
    
    let data = viewModel.data[indexPath.row]
    let reminderVC = RemindersViewController(category: data)
    navigationController?.pushViewController(reminderVC, animated: true)
  }

  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let categoryName = viewModel.data[indexPath.row].name

    // deletion
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
      let alert = UIAlertController(title: "Delete \"\(categoryName)\"",
                                    message: "This will delete all reminders in this list",
                                    preferredStyle: .alert)
      let canelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

      let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
        self?.viewModel.deleteCategory(indexPath: indexPath) {
          self?.tableView.deleteRows(at: [indexPath], with: .automatic)
          self?.collectionView.reloadData()
        }
      }

      alert.addAction(canelAction)
      alert.addAction(deleteAction)

      self?.present(alert, animated: true, completion: nil)
      completion(true)
    }
    deleteAction.image = UIImage(systemName: "trash.fill")

    let detailAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
      guard let viewModel = self?.viewModel else { return }

      let vc = ListSettingViewController(with: ListSettingViewModel(with: viewModel.data[indexPath.row]))
      self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
      completion(true)
    }
    detailAction.image = UIImage(systemName: "info.circle.fill")

    return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
  }
}

extension MainViewController {
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { tableView.isEditing }
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    viewModel.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
}

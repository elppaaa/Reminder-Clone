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
}

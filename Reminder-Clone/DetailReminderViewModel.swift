//
// Created by JK on 2021/03/19.
//

import UIKit

@objc protocol DetailReminderTableViewDelegate {
  @objc optional var tableView: UITableView? { get }
}

class DetailReminderViewModel: NSObject {
  var _tableView: UITableView?
  
}

extension DetailReminderViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: will change
    switch section {
    case 0:
      return 3
    case 1:
      return 4
    case 2:
      return 1
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableViewCellSelector(indexPath: indexPath)
  }
  
  // MARK: -  Cell Selector
  func tableViewCellSelector(indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      cell = DetailReminderInputCell(placeHolder: "Title", delegate: self)
    case (0, 1):
      cell = DetailReminderInputCell(placeHolder: "Notes", delegate: self)
    case (0, 2):
      cell = DetailReminderInputCell(placeHolder: "URL", delegate: self)
      
    case (1, 0):
      cell = DetailReminderToggleCell(
        title: "Date", image: .calendar, color: .systemRed, delegate: self)
    case (1, 1):
      cell = DetailReminderDateCell(delegate: self)
    case (1, 2):
      cell = DetailReminderToggleCell(
        title: "Time", image: .clock, color: .systemBlue, delegate: self)
    case (1, 3):
      cell = DetailReminderDateCell(isTimePicker: true, delegate: self)
      
    case (2, 0):
      cell = DetailReminderToggleCell(
        title: "Repeat", image: .trayCircle, color: .systemGray, delegate: self)
      
    default:
      cell = UITableViewCell()
    }
    
    cell.selectionStyle = .none
    
    return cell
  }
  
}

extension DetailReminderViewModel: UITableViewDelegate { }

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  var tableView: UITableView? { _tableView }
}

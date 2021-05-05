//
// Created by JK on 2021/03/19.
//

import UIKit

protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
  func setValue<T>(key: TaskAttributesKey, value: T);
}

class DetailReminderViewModel: NSObject {
  var _tableView: UITableView?
  var delegateVC: ViewControllerDelegate?
  var dict = [TaskAttributesKey: Any]()
  
  var cells: [[UITableViewCell]] = [
    // 0
    [
      DetailReminderInputCell(placeHolder: "Title", type: .title),
      DetailReminderInputCell(placeHolder: "Notes", type: .notes),
      DetailReminderInputCell(placeHolder: "URL", type: .URL)
    ],
    // 1
    [
      DetailReminderToggleCell(
        title: "Date", image: R.Image.calendar.image, color: .systemRed, type: .date),
      DetailReminderDateCell(isTimePicker: false, type: .date),
      DetailReminderToggleCell(
        title: "Time", image: R.Image.clock.image, color: .systemBlue, type: .time),
      DetailReminderDateCell(isTimePicker: true, type: .time)
    ],
    // 2
    [
      DetailReminderToggleCell(
        title: "Location", image: R.Image.location.image, color: .systemBlue, type: .location)
    ],
    [
      DetailReminderToggleCell(
        title: "Flag", image: R.Image.flag.image, color: .systemOrange, type: .flag)
    ],
    [
      UITableViewCell(style: .value1, reuseIdentifier: nil),
      UITableViewCell(style: .value1, reuseIdentifier: nil),
    ],
    [
      UITableViewCell(style: .value1, reuseIdentifier: nil)
    ],
    [
      UITableViewCell(style: .value1, reuseIdentifier: nil)
    ],
  ]
  
}

extension DetailReminderViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    cells.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cells[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableViewCellSelector(indexPath: indexPath)
  }
  
}

extension DetailReminderViewModel: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (4, 0):
      if #available(iOS 13, *) {
        let vc = DetailReminderPriorityViewController(style: .insetGrouped)
        delegateVC?.pushVC(vc, animated: true)
      } else {
        let vc = DetailReminderPriorityViewController(style: .grouped)
        delegateVC?.pushVC(vc, animated: true)
      }
  
    case (4, 1):
      let vc = DetailReminderListViewController(style: .plain)
      delegateVC?.pushVC(vc, animated: true)
    case (5, 0):
      let vc = DetailReminderSubtasksViewController(style: .grouped)
      delegateVC?.pushVC(vc, animated: true)
      
    default:
      break
    }
  }
}

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  func setValue<T>(key: TaskAttributesKey, value: T) {
    dict[key] = value
  }
  
  var tableView: UITableView? {
    _tableView
  }
}

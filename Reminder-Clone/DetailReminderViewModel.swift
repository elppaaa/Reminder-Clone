//
// Created by JK on 2021/03/19.
//

import UIKit

@objc protocol DetailReminderTableViewDelegate {
  var tableView: UITableView? { get }
}

class DetailReminderViewModel: NSObject {
  var _tableView: UITableView?
//  var cells: [[UITableViewCell?]]
	var cellViews: [[(isUsed: Bool, isVisible: Bool)]] = [
    [(true, true), (true, true), (true, true)],
    [(true, true), (true, true), (true, true), (true, true)],
		[(true, true)],
    [(true, true)],
  ]
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
        title: "Date", image: .calendar, color: .systemRed, type: .date),
      DetailReminderDateCell(isTimePicker: false, type: .date),
      DetailReminderToggleCell(
        title: "Time", image: .clock, color: .systemBlue, type: .time),
      DetailReminderDateCell(isTimePicker: true, type: .time)
    ],
    // 2
    [
      DetailReminderToggleCell(
        title: "Location", image: .location, color: .systemBlue, type: .location)
    ],
    [
      DetailReminderToggleCell(
        title: "Flag", image: .flag, color: .systemOrange, type: .flag)
    ]
  ]

}

extension DetailReminderViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    cellViews.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cellViews[section].filter { $0.isVisible }.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableViewCellSelector(indexPath: indexPath)
  }

}

extension DetailReminderViewModel: UITableViewDelegate { }

extension DetailReminderViewModel: DetailReminderTableViewDelegate {
  var tableView: UITableView? { _tableView }
}

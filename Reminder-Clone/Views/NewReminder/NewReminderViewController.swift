//
//  NewReminderViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/06.
//

import UIKit

class NewReminderViewController: UITableViewController {
  required init?(coder: NSCoder) { fatalError("No not use this initialzier") }
  override init(style: UITableView.Style) { super.init(style: style) }

  convenience init() {
    self.init(style: .insetGrouped)
    commonInit()
  }

  func commonInit() {
    configNavigation()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = CGFloat(50)

    tableView.register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.identifier)
  }
}

extension NewReminderViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1:
      return 1
    case 2:
      return 1
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      return DetailReminderInputCell(placeHolder: "Title", type: .title)
    case (0, 1):
      return DetailReminderInputCell(placeHolder: "Notes", type: .notes)

    case (1,0):
      let cell = UITableViewCell()
      cell.textLabel?.text = "Details"
      cell.accessoryType = .disclosureIndicator
      return cell
    case (2,0):
      let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
      cell.textLabel?.text = "List"
      
      let category = HomeListTableViewModel.shared.data[0]
      cell.detailTextLabel?.attributedText = BadgeText(color: category.color, text: category.name).text

      cell.accessoryType = .disclosureIndicator
      return cell
    default:
      return UITableViewCell()
    }

  }
}

extension NewReminderViewController {
  func configNavigation() {
    title = "New Reminder"

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
  }
}

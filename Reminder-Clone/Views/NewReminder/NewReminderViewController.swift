//
//  NewReminderViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/06.
//

import UIKit
import Combine

class NewReminderViewController: UITableViewController {
  convenience init() {
    self.init(style: .insetGrouped)
    commonInit()
    binding()
  }

  let viewModel = NewReminderViewModel()

  let cancelButton =
    UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonTapped))
  let addButton =
    UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didAddButtonTapped))

  var cancelBag = Set<AnyCancellable>()

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
      let dataType = TaskAttributesKey.title
      let vc = DetailReminderInputCell(placeHolder: "Title", type: dataType)

      vc.textView.textPublisher
        .removeDuplicates()
        .sink { [weak self] in
          self?.viewModel.set(key: dataType, value: $0)
        }
        .store(in: &cancelBag)

      return vc

    case (0, 1):
      let dataType = TaskAttributesKey.notes
      let vc = DetailReminderInputCell(placeHolder: "Notes", type: dataType)

      vc.textView.textPublisher
        .removeDuplicates()
        .sink { [weak self] in
          self?.viewModel.set(key: dataType, value: $0)
        }
        .store(in: &cancelBag)

      return vc

    case (1,0):
      let cell = UITableViewCell()
      cell.textLabel?.text = "Details"
      cell.accessoryType = .disclosureIndicator
      return cell
    case (2,0):
      let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
      cell.textLabel?.text = "List"
      
      let category = viewModel.category
      cell.detailTextLabel?.attributedText = BadgeText(color: category.color, text: category.name).text

      cell.accessoryType = .disclosureIndicator
      return cell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch (indexPath.section, indexPath.row) {
    case (1, 0), (2, 0):
      return indexPath
    default:
      return nil
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (1, 0):
      return // detail page
    case (2, 0):
      let vc = DetailReminderListViewController()
      vc.currentTask = viewModel.task
      vc.completionHandler = { tableView.reloadRows(at: [indexPath], with: .none) }
      navigationController?.pushViewController(vc, animated: true)
    default:
      return
    }
  }
}

extension NewReminderViewController {
  func configNavigation() {
    title = "New Reminder"

    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem = addButton
  }

  @objc
  func didAddButtonTapped() {

  }

  @objc
  func didCancelButtonTapped() {

  }

  func binding() {
    viewModel.task.publisher(for: \.title)
      .map { $0.count > 0 }
      .removeDuplicates()
      .sink { [weak self] in
        self?.addButton.isEnabled = $0
      }
      .store(in: &cancelBag)

  }
}

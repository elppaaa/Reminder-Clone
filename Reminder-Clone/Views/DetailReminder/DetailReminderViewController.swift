//
//  DetailReminderViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class DetailReminderViewController: UITableViewController, ViewControllerDelegate {
  var viewModel = DetailReminderViewModel()
  var tableViewHeight: NSLayoutConstraint?
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

  override func viewDidLoad( ) {
    super.viewDidLoad()
    title = "Detail"
    view.backgroundColor = R.Color.applicationBackground
    commonInit()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    defaultNavigationConfig()
    navigationController?.isToolbarHidden = true
  }
  
  func commonInit( ) {
    viewModel.delegateVC = self

    configTableView()
    configNavigationBar()
  }
}

// MARK: - Navigation Setting
extension DetailReminderViewController {
  fileprivate func configNavigationBar( ) {
    title = "Detail"
    let cancelNavigationItem = UIBarButtonItem(
      title: "Cancel", style: .plain, target: self, action: #selector(didLeftNavigationBarButtonClicked))
    let doneNavigationItem = UIBarButtonItem(
      title: "Done", style: .done, target: self, action: #selector(didRightNavigationBarButtonClicked))
    
    navigationItem.leftBarButtonItem = cancelNavigationItem
    navigationItem.rightBarButtonItem = doneNavigationItem
  }
  
  @objc func didLeftNavigationBarButtonClicked( ) {
    if !isEditing {
      dismiss(animated: true)
    }
  }
  
  @objc func didRightNavigationBarButtonClicked( ) {
    // TODO: save to core data
    dismiss(animated: true)
  }
  
  @objc func injected( ) {
    let vc = DetailReminderViewController()
    homeInject(vc)
  }
}

// MARK: - Config TableView
extension DetailReminderViewController {
  func configTableView() {
    tableView.register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.identifier)
    tableView.register(DetailReminderDateCell.self, forCellReuseIdentifier: DetailReminderDateCell.identifier)
    tableView.register(DetailReminderToggleCell.self, forCellReuseIdentifier: DetailReminderToggleCell.identifier)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50
    tableView.keyboardDismissMode = .interactive
  }
}

extension DetailReminderViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    cells.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cells[section].count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    cell = cells[indexPath]

    switch (indexPath.section, indexPath.row) {
    case (4, 0):
      cell.textLabel?.text = "Priority"
      cell.detailTextLabel?.text = "None" // entity.priority
      cell.accessoryType = .disclosureIndicator
    case (4, 1):
      cell.textLabel?.text = "List"
      cell.detailTextLabel?.text = "미리 알림" // entity
      cell.accessoryType = .disclosureIndicator
    case (5, 0):
      cell.textLabel?.text = "Subtasks"
      cell.detailTextLabel?.text = "0" // entity.child.count
      cell.accessoryType = .disclosureIndicator
    case (6, 0):
      cell.textLabel?.text = "Add Image"
      cell.textLabel?.textColor = .systemBlue
    default:
      break
    }

    if let _cell = cell as? DetailReminderViewCellBase {
      _cell.delegate = viewModel
    }

    cell.selectionStyle = .none

    return cell
  }
}

extension DetailReminderViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (4, 0):
      let vc = DetailReminderPriorityViewController(style: .insetGrouped)
      navigationController?.pushViewController(vc, animated: true)

    case (4, 1):
      let vc = DetailReminderListViewController(style: .plain)
      navigationController?.pushViewController(vc, animated: true)
    case (5, 0):
      let vc = DetailReminderSubtasksViewController(style: .grouped)
      navigationController?.pushViewController(vc, animated: true)

    default:
      break
    }
  }
}

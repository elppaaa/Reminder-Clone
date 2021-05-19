//
//  DetailReminderViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit
import Combine

class DetailReminderViewController: UITableViewController, ViewControllerDelegate {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  init(task: Task) {
    viewModel = DetailReminderViewModel(task: task)
    super.init(style: .insetGrouped)
  }

  lazy var cancelNavigationItem: UIBarButtonItem = UIBarButtonItem(
    title: "Cancel", style: .plain, target: self, action: #selector(didLeftNavigationBarButtonTapped))
  lazy var doneNavigationItem = UIBarButtonItem(
    title: "Done", style: .done, target: self, action: #selector(didRightNavigationBarButtonTapped))

  var cancelBag = Set<AnyCancellable>() 

  var completionHandler: (() -> Void)?
  let viewModel: DetailReminderViewModel
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
    configTableView()
    configNavigationBar()
  }
}

// MARK: - Navigation Setting
extension DetailReminderViewController {
  fileprivate func configNavigationBar( ) {
    title = "Detail"

    navigationItem.leftBarButtonItem = cancelNavigationItem
    navigationItem.rightBarButtonItem = doneNavigationItem
  }
  
  @objc
  func didLeftNavigationBarButtonTapped( ) {
    if viewModel.task.hasChanges {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let discardAction = UIAlertAction(title: "Discard Changes", style: .destructive) {[weak self] _ in
        self?.dismiss(animated: true, completion: {
          self?.viewModel.rollBack()
        })
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

      alert.addAction(discardAction)
      alert.addAction(cancelAction)

      present(alert, animated: true)
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
  
  @objc
  func didRightNavigationBarButtonTapped( ) {
    viewModel.save()
    completionHandler?()
    dismiss(animated: true)
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
    case (0, 0):
      if let cell = cell as? DetailReminderInputCell {
        if let type = cell.dataType, let text = viewModel.task.get(type) as? String {
          cell.textView.text = text
          cell.textView.textColor = .label
        }

        cell.textView.textPublisher
          .sink { [weak self] in
            if $0 == "" {
              self?.doneNavigationItem.isEnabled = false
            } else {
              self?.doneNavigationItem.isEnabled = true
              guard let type = cell.dataType else { return }
              self?.viewModel.task.set(key: type, value: $0)
            }
          }
          .store(in: &cancelBag)
      }

    case (0, 1), (0, 2):
      if let cell = cell as? DetailReminderInputCell {
        if let type = cell.dataType {
          if let type = cell.dataType, let text = viewModel.task.get(type) as? String {
            cell.textView.text = text
            cell.textView.textColor = .label
          }

          viewModel.$task
            .compactMap { $0.get(type) as? String }
            .filter { $0 != "" }
            .assign(to: \.text, on: cell.textView)
            .store(in: &cancelBag)
        }

        let placeHolder = cell.textViewPlaceholder
        cell.textView.textPublisher
          .filter { $0 != placeHolder }
          .sink { [weak self] in
            guard let type = cell.dataType else { return }
            if $0 == "" {
              self?.viewModel.task.set(key: type, value: nil)
            } else {
              self?.viewModel.task.set(key: type, value: $0)
            }
          }
          .store(in: &cancelBag)
      }

    case (1,0), (1, 2), (2, 0):
      if let cell = cell as? DetailReminderToggleCell {

        if let type = cell.dataType {
          viewModel.$task
            .sink {
              if $0.get(type) != nil {
                cell.toggle.isOn = true
              } else {
                cell.toggle.isOn = false
              }
            }
            .store(in: &cancelBag)
        }

        cell.toggle.publisher(for: .valueChanged)
          .compactMap { $0 as? UISwitch }
          .map(\.isOn)
          .filter { !$0 }
          .sink { [weak self] _ in
            guard let type = cell.dataType else { return }
            self?.viewModel.task.set(key: type, value: nil)
          }
          .store(in: &cancelBag)
      }
    case (4, 0):
      cell.textLabel?.text = "Priority"
      cell.detailTextLabel?.text = TaskPriority(rawValue: viewModel.task.priority)?.text ?? "None"
      cell.accessoryType = .disclosureIndicator
    case (4, 1):
      cell.textLabel?.text = "List"
//      cell.detailTextLabel?.text = viewModel.task.category?.name ?? "Unkown List"
      viewModel.task
        .publisher(for: \.category?.name)
        .sink { cell.detailTextLabel?.text = $0 }
        .store(in: &cancelBag)
      cell.accessoryType = .disclosureIndicator
    case (5, 0):
      cell.textLabel?.text = "Subtasks"
      cell.detailTextLabel?.text = String(viewModel.task.subtasks?.count ?? 0)
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
      vc.currentCategory = viewModel.task.category
//      vc.completionHandler = { tableView.reloadData() }
      navigationController?.pushViewController(vc, animated: true)
    case (5, 0):
      let vc = DetailReminderSubtasksViewController(style: .grouped)
      navigationController?.pushViewController(vc, animated: true)

    default:
      break
    }
  }
}

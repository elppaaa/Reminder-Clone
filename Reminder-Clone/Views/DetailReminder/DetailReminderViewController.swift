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
  var collapsedCells = [DetailReminderViewCellBase]()
  
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
      DetailReminderToggleCell(
        title: "Time", image: R.Image.clock.image, color: .systemBlue, type: .time),
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Detail"
    view.backgroundColor = R.Color.applicationBackground
    commonInit()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    defaultNavigationConfig()
    navigationController?.isToolbarHidden = true
  }
  
  func commonInit() {
    configTableView()
    configNavigationBar()
    navigationController?.presentationController?.delegate = self
  }
}

// MARK: - Navigation Setting
extension DetailReminderViewController {
  fileprivate func configNavigationBar() {
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
          self?.viewModel.unsetUndoManager()
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
  func didRightNavigationBarButtonTapped() {
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

    collapsedCells.append(DetailReminderDateCell(isTimePicker: false, type: .date))
    collapsedCells.append(DetailReminderDateCell(isTimePicker: true, type: .time))
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
    cell.selectionStyle = .none

    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      if let cell = cell as? DetailReminderInputCell {
        if let type = cell.dataType, let text = viewModel.task.get(type) as? String {
          cell.textView.text = text
          cell.textView.textColor = .label
        }
        
        cell.textView.textPublisher
          .removeDuplicates()
          .sink { [weak self] in
            if $0 == "" {
              self?.doneNavigationItem.isEnabled = false
            } else {
              self?.doneNavigationItem.isEnabled = true
              guard let type = cell.dataType else { return }
              self?.viewModel.set(key: type, value: $0)
            }
          }
          .store(in: &cancelBag)
        
        cell.textViewDidChange(cell.textView)
      }

    case (0, 1), (0, 2):
      if let cell = cell as? DetailReminderInputCell {
        if let type = cell.dataType, let text = viewModel.task.get(type) as? String {
          cell.textView.text = text
          cell.textView.textColor = .label
        }
        
        let placeHolder = cell.textViewPlaceholder
        cell.textView.textPublisher
          .filter { $0 != placeHolder }
          .sink { [weak self] in
            guard let type = cell.dataType else { return }
            if $0 == "" {
              self?.viewModel.setNil(type)
            } else {
              self?.viewModel.set(key: type, value: $0)
            }
          }
          .store(in: &cancelBag)
        
        cell.textViewDidChange(cell.textView)
      }

    case (1, 0), (1, 2):
      if let cell = cell as? DetailReminderToggleCell {
        
        if let type = cell.dataType {
          if viewModel.task.get(type) != nil {
            cell.toggle.isOn = true
          } else {
            cell.toggle.isOn = false
          }
          cell.detailTextLabel?.text = viewModel.dateText(type)

          if indexPath.row == 0 {
            viewModel.task.publisher(for: \.date)
              .sink { [weak self] _ in cell.detailTextLabel?.text = self?.viewModel.dateText(type) }
              .store(in: &cancelBag)
          } else {
            viewModel.task.publisher(for: \.time)
              .sink { [weak self] _ in cell.detailTextLabel?.text = self?.viewModel.dateText(type) }
              .store(in: &cancelBag)
          }
        }
        
        cell.toggle.publisher(for: .valueChanged)
          .compactMap { $0 as? UISwitch }
          .map(\.isOn)
          .filter { $0 }
          .sink { [weak self]  in
            guard let type = cell.dataType else { return }
            switch $0 {
            case true:
              cell.selectionStyle = .default
              self?.viewModel.set(key: type, value: Date())
            case false:
              cell.selectionStyle = .none
              self?.viewModel.setNil(type)
            }
          }
          .store(in: &cancelBag)
      }
    case (1, 1), (1, 3):
      if let cell = cell as? DetailReminderDateCell {
        if let type = cell.dataType {
          if let value = viewModel.task.get(type) as? Date {
            cell.datePicker.setDate(value, animated: false)
          }

          cell.datePicker.publisher(for: .valueChanged)
            .compactMap { $0 as? UIDatePicker }
            .map(\.date)
            .sink { [weak self] in self?.viewModel.set(key: type, value: $0) }
            .store(in: &cancelBag)
        }
      }

    case (2, 0):
      if let cell = cell as? DetailReminderToggleCell {

        if let type = cell.dataType {
          if viewModel.task.get(type) != nil {
            cell.toggle.isOn = true
          } else {
            cell.toggle.isOn = false
          }
        }

        cell.toggle.publisher(for: .valueChanged)
          .compactMap { $0 as? UISwitch }
          .map(\.isOn)
          .filter { !$0 }
          .sink { [weak self] _ in
            guard let type = cell.dataType else { return }
            self?.viewModel.setNil(type)
          }
          .store(in: &cancelBag)
      }
    case (3, 0):
      if let cell = cell as? DetailReminderToggleCell {
        cell.toggle.isOn = viewModel.task.flag
        
        cell.toggle.publisher(for: .valueChanged)
          .compactMap { $0 as? UISwitch }
          .map(\.isOn)
          .sink { [weak self] in self?.viewModel.task.set(key: .flag, value: $0) }
          .store(in: &cancelBag)
        
      }

    case (4, 0):
      cell.textLabel?.text = "Priority"
      cell.detailTextLabel?.text = TaskPriority(rawValue: viewModel.task.priority)?.text ?? "None"
      cell.accessoryType = .disclosureIndicator
    case (4, 1):
      cell.textLabel?.text = "List"
      viewModel.$task
        .compactMap { $0.category?.name }
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
    
    if let cell = cell as? DetailReminderViewCellBase {
      cell.delegate = self
    }

    return cell
  }
}

extension DetailReminderViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    defer { tableView.deselectRow(at: indexPath, animated: true) }

    switch (indexPath.section, indexPath.row) {
    case (1, 0), (1, 1), (1, 2):
      guard let cell = tableView.cellForRow(at: indexPath) as? DetailReminderToggleCell,
            cell.toggle.isOn, let dataType = cell.dataType else { return }

      if tableView.cellForRow(at: indexPath.nextRow) is DetailReminderDateCell {
        deleteNextRow(indexPath: indexPath, key: dataType)
      } else {
        insertNextRow(indexPath: indexPath, key: dataType)
      }

    case (4, 0):
      let vc = DetailReminderPriorityViewController(viewModel: viewModel)
      vc.completionHandler = { tableView.reloadRows(at: [indexPath], with: .none) }
      navigationController?.pushViewController(vc, animated: true)

    case (4, 1):
      let vc = DetailReminderListViewController(style: .plain)
      vc.currentTask = viewModel.task
      vc.completionHandler = { tableView.reloadRows(at: [indexPath], with: .none) }
      navigationController?.pushViewController(vc, animated: true)
    case (5, 0):
      let vc = DetailReminderSubtasksViewController(task: viewModel.task)
      navigationController?.pushViewController(vc, animated: true)

    default:
      break
    }
  }

  func deleteNextRow(indexPath: IndexPath, key: TaskAttributesKey) {
    guard let _cell = tableView.cellForRow(at: indexPath.nextRow) as? DetailReminderViewCellBase,
          let dataType = _cell.dataType,
          dataType == key else { return }

    if let cell = cells[indexPath.section].remove(at: indexPath.row + 1) as? DetailReminderViewCellBase {
      collapsedCells.append(cell)
      tableView.deleteRows(at: [indexPath.nextRow], with: .automatic)
    }
  }

  func insertNextRow(indexPath: IndexPath, key: TaskAttributesKey) {
    guard let index = findCollapsedCell(with: key) else { return }
    let cell = collapsedCells.remove(at: index)
    cells[indexPath.section].insert(cell, at: indexPath.nextRow.row)
    tableView.insertRows(at: [indexPath.nextRow], with: .automatic)
  }

  func findCollapsedCell(with key: TaskAttributesKey) -> Int? {
    collapsedCells.firstIndex { $0.dataType == key }
  }
}

extension DetailReminderViewController: DetailReminderViewCellBaseDelegate {
  func updateLayout(_ handler: (() -> Void)?) {
    tableView.performBatchUpdates { handler?() }
  }
}

// MARK: - Navigation Dismiss event
extension DetailReminderViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    didLeftNavigationBarButtonTapped()
  }

  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    !viewModel.task.hasChanges
  }
}

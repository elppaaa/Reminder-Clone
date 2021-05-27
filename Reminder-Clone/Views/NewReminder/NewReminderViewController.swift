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
  }

  let viewModel = NewReminderViewModel()

  lazy var cancelButton =
    UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonTapped))
  lazy var addButton =
    UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didAddButtonTapped))

  var cancelBag = Set<AnyCancellable>()

  func commonInit() {
    configNavigation()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = CGFloat(50)

    tableView.register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.identifier)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    commonInit()
    binding()
    navigationController?.presentationController?.delegate = self
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
          if $0 == "" {
            self?.viewModel.setNil(dataType)
          } else {
            self?.viewModel.set(key: dataType, value: $0)
          }
        }
        .store(in: &cancelBag)

      return vc

    case (0, 1):
      let dataType = TaskAttributesKey.notes
      let vc = DetailReminderInputCell(placeHolder: "Notes", type: dataType)

      vc.textView.textPublisher
        .removeDuplicates()
        .sink { [weak self] in
          if $0 == "" {
            self?.viewModel.setNil(dataType)
          } else {
            self?.viewModel.set(key: dataType, value: $0)
          }
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
    viewModel.save()
    dismiss(animated: true, completion: nil)
  }

  @objc
  func didCancelButtonTapped() {
    if viewModel.task.hasChanges {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let discardAction = UIAlertAction(title: "Discard Changes", style: .destructive) {[weak self] _ in
        self?.viewModel.cancel()
        self?.dismiss(animated: true)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

      alert.addAction(discardAction)
      alert.addAction(cancelAction)

      present(alert, animated: true)
    } else {
      viewModel.cancel()
      dismiss(animated: true, completion: nil)
    }
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

extension NewReminderViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    !viewModel.task.hasChanges
  }

  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    didCancelButtonTapped()
  }

  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    viewModel.cancel()
  }
}

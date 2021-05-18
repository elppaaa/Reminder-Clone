//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit
import Combine

// TODO: Get from core data

class RemindersViewController: UITableViewController {
  // TODO: Get from core data
  required init?(coder: NSCoder) { fatalError("Do not user initializer") }
  fileprivate var viewModel: RemindersTableViewModel

  init(_ category: Category) {
    viewModel = RemindersTableViewModel(category: category)
    super.init(style: .plain)
  }

  var cancelBag = Set<AnyCancellable>()

  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackground
    tableView.keyboardDismissMode = .interactive

    configLayout()
    configBinding()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    PersistentManager.shared.saveContext()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    defaultNavigationConfig()
    let attribute = [NSAttributedString.Key.foregroundColor: viewModel.category.color]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
    tableView.reloadData()
    super.viewWillAppear(true)
  }

}

// MARK: - Layout
extension RemindersViewController {
  fileprivate func configLayout() {
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
  }
}

// MARK: - DataSource
extension RemindersViewController {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.tasks.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else {
      fatalError("Cell Not Founded")
    }

    cell.color = viewModel.category.color
    let data = viewModel.tasks[indexPath.row]
    cell.textView.text = data.title
    cell.isDone = data.isDone

    cell.layoutUpdate = { [weak self] in
      self?.tableView.beginUpdates()
      self?.tableView.endUpdates()
    }

    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.$isDone
        .sink { data.isDone = $0 }
    )

    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.textPublisher
        .sink { data.title = $0 }
    )

    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.endEditingPublisher
        .filter { $0 == "" }
        .sink { [weak self] _ in
          if let index = self?.viewModel.index(of: data) {
            self?.viewModel.delete(index: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
          }
        }
    )

    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.flag)
        .assign(to: \.flagVisible, on: cell)
    )

    return cell
  }
}

// MARK: - Delegate
extension RemindersViewController {
  override public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    PersistentManager.shared.saveContext()
    let object = viewModel.tasks[indexPath.row]
    let vc = DetailReminderViewController(task: object)
    vc.completionHandler = { tableView.reloadRows(at: [indexPath], with: .none) }

    navigationController?.present(
      UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
}

// MARK: - Swipe Action
extension RemindersViewController {
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, result in
      self?.viewModel.delete(index: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      result(true)
    }

    let flagAction = UIContextualAction(style: .normal, title: "Flag") { [weak self] _, _, result in
      self?.viewModel.tasks[indexPath.row].flag.toggle()
      result(true)
    }
    flagAction.backgroundColor = .systemOrange

    let detailAction = UIContextualAction(style: .normal, title: "Detail") { [weak self] _, _, result in
      self?.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
      result(true)
    }

    return UISwipeActionsConfiguration(actions: [deleteAction, flagAction, detailAction])
  }
}

// MARK: - Binding
extension RemindersViewController {
  func configBinding() {
    view.publisher(.tap)
      .sink { [weak self] _ in
        if self?.viewModel.tasks.last?.title != "" {
          _ = self?.viewModel.newTask()
          guard let count = self?.viewModel.tasks.count else { return }
          let index = IndexPath(row: count - 1, section: 0)
          self?.tableView.insertRows(at: [index], with: .fade)
          if let cell = self?.tableView.cellForRow(at: index) as? ReminderTableViewCell {
            cell.textView.becomeFirstResponder()
          }
        } else {
          self?.tableView.endEditing(true)
        }
      }
      .store(in: &cancelBag)
  }
}

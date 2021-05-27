//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit
import Combine

class RemindersViewController: UITableViewController {
  required init?(coder: NSCoder) { fatalError("Do not user initializer") }
  
  let viewModel: RemindersTableViewModel
  
  init(category: Category) {
    viewModel = RemindersTableViewModel(category: category)
    super.init(style: .plain)
    title = category.name
  }
  
  var cancelBag = Set<AnyCancellable>()
  
  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 45
    
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
    cell.priority = data.priority
    cell.delegate = self
    cell.id = data.objectID

    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.title)
          .removeDuplicates()
          .sink { cell.textView.text = $0 }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.$isDone
        .removeDuplicates()
        .sink { data.set(key: .isDone, value: $0) }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.textPublisher
        .removeDuplicates()
        .sink { data.set(key: .title, value: $0) }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.flag)
          .removeDuplicates()
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
    if object.title == "" {
      object.set(key: .title, value: "New Reminder")
    }
    
    let vc = DetailReminderViewController(task: object)

    navigationController?.present(
      UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
}

// MARK: - Swipe Action
extension RemindersViewController {
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, result in
      guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell,
            let id = cell.id else { return }

      self?.viewModel.delete(id: id) { [weak self] _ in
        self?.tableView.deleteRows(at: [indexPath], with: .fade)
      }

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
      .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        if self?.viewModel.tasks.last?.title != "" {
          guard let last = self?.viewModel.tasks.last else { return }
          self?.insertTask(id: last.objectID, animate: .none)
        } else {
          self?.tableView.endEditing(true)
        }
      }
      .store(in: &cancelBag)
  }
}

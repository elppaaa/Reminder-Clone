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
        .receive(on: RunLoop.main)
        .removeDuplicates()
        .sink { cell.textView.text = $0 }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.$isDone
        .receive(on: RunLoop.main)
        .removeDuplicates()
        .sink { data.set(key: .isDone, value: $0) }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      cell.textView.textPublisher
        .receive(on: RunLoop.main)
        .removeDuplicates()
        .sink { data.set(key: .title, value: $0) }
    )
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.flag)
        .receive(on: RunLoop.main)
        .removeDuplicates()
        .assign(to: \.flagVisible, on: cell)
    )

    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.priority)
        .receive(on: RunLoop.main)
        .removeDuplicates()
        .sink { cell.priority = $0 }
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

// MARK: - Tap Gesture Recognizer
extension RemindersViewController: UIGestureRecognizerDelegate {
  func configGesture() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTableViewTapped))
    gesture.delegate = self
    tableView.addGestureRecognizer(gesture)

    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
      .map { _ in true }
      .assign(to: \.isKeyboardHidden, on: self)
      .store(in: &cancelBag)

    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .map { _ in false }
      .assign(to: \.isKeyboardHidden, on: self)
      .store(in: &cancelBag)

    NotificationCenter.default.publisher(for: .CategoryChanged, object: viewModel.category)
      .compactMap { $0.object as? Category }
      .map(\.tasks?.count)
      .removeDuplicates()
      .sink {[weak self] _ in
        self?.viewModel.reload()
        self?.tableView.reloadData()
      }
      .store(in: &cancelBag)
  }

  @objc
  func didTableViewTapped() {
    if isKeyboardHidden {
      guard let id = viewModel.tasks.last?.objectID else { return }
      insertTask(id: id, animate: .none)
    } else {
      tableView.endEditing(false)
    }
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if gestureRecognizer is UITapGestureRecognizer, touch.view == tableView { return true }
    return false
  }
}

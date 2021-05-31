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

  @Published var isTableViewEditing = false 
  
  var cancelBag = Set<AnyCancellable>()
  fileprivate var isKeyboardHidden = true
  
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
    tableView.allowsMultipleSelectionDuringEditing = true
    tableView.allowsSelection = true
    configLayout()
    configGesture()
    configBinding()
    setBarButtonMore()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.endEditing(true)
    PersistentManager.shared.saveContext()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    defaultNavigationConfig()
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
    viewModel.tasksCancelBag[data.objectID]?.removeAll()
    
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
    
    viewModel.tasksCancelBag[data.objectID]?.insert(
      data.publisher(for: \.isDone)
        .debounce(for: .seconds(3), scheduler: RunLoop.main)
        .filter { $0 }
        .sink { [weak self] _ in self?.hideCell(id: data.objectID) }
    )

    viewModel.tasksCancelBag[data.objectID]?.insert(
      $isTableViewEditing
        .sink {
          cell.selectionStyle = $0 ? .default : .none
          cell.toggleButton.isHidden = $0 ? true : false
        }
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

  // move cells
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    viewModel.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
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
  func setCellInsertGesture() {
    let addTaskGesture = UITapGestureRecognizer(target: self, action: #selector(didTableViewTapped))
    addTaskGesture.delegate = self
    tableView.addGestureRecognizer(addTaskGesture)
  }

  func configGesture() {
    setCellInsertGesture()
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.isKeyboardHidden = true
        self?.setBarButtonMore()
      }
      .store(in: &cancelBag)
    
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.isKeyboardHidden = false
        self?.setBarButtonDone()
      }
      .store(in: &cancelBag)
    
  }
  
  @objc
  func didTableViewTapped() {
    if tableView.isEditing { return }
    if isKeyboardHidden {
      if viewModel.tasks.count == 0 { insertTask(index: 0, animate: .none) }
      else {
        guard let id = viewModel.tasks.last?.objectID else { return }
        insertTask(id: id, animate: .none)
      }
    } else {
      tableView.endEditing(false)
    }
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if gestureRecognizer is UITapGestureRecognizer, touch.view == tableView { return true }
    return false
  }

  // MARK: - Config Binding
  func configBinding() {
    
    //  Reload when data updated
    NotificationCenter.default
      .publisher(for: .CategoryChanged, object: viewModel.category)
      .sink {
        [weak self] _ in
        self?.viewModel.reload()
        self?.tableView.reloadData()
      }
      .store(in: &cancelBag)
    
    viewModel.category
      .publisher(for: \.colorInt)
      .receive(on: RunLoop.main)
      .sink {
        [weak self] color in
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor(hex: Int(color))]
        self?.navigationController?.navigationBar.largeTitleTextAttributes = attribute
        self?.tableView.reloadData()
      }
      .store(in: &cancelBag)

    viewModel.category.publisher(for: \.name)
      .compactMap { $0 }
      .receive(on: RunLoop.main)
      .assign(to: \.title, on: self)
      .store(in: &cancelBag)
    
    viewModel.category.publisher(for: \.isShownCompleted)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.setBarButtonMore()
      }
      .store(in: &cancelBag)

  }

}

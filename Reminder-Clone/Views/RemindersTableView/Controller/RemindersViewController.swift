//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit
import Combine

final class RemindersViewController: UITableViewController {
  required init?(coder: NSCoder) { fatalError("Do not user initializer") }
  let viewModel: RemindersTableViewModel

  init(category: Category) {
    viewModel = RemindersTableViewModel(category: category)
    super.init(style: .plain)
    title = category.name
  }

  var isKeyboardHidden = true
  @Published var isTableViewEditing = false
  var cancelBag = Set<AnyCancellable>()
}


// MARK: - View LifeCycle
extension RemindersViewController {
  override func loadView() {
    super.loadView()
    tableViewConfig()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackground
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

  fileprivate func tableViewConfig() {
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 45
    tableView.keyboardDismissMode = .interactive
    tableView.allowsMultipleSelectionDuringEditing = true
    tableView.allowsSelection = true
    tableView.dragInteractionEnabled = true
    tableView.dragDelegate = self
    tableView.dropDelegate = self
  }
}

// MARK: - Config Binding
extension RemindersViewController {
  fileprivate func configBinding() {
    
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

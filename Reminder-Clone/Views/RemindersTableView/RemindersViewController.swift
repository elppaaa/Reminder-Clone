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
  var pagePrimaryColor: UIColor = .clear
  fileprivate let viewModel = RemindersTableViewModel()
  fileprivate var cacnelBag = Set<AnyCancellable>()

  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    viewModel.primaryColor = pagePrimaryColor
    tableView.estimatedRowHeight = 40
    tableView.allowsMultipleSelectionDuringEditing = true
    tableView.keyboardDismissMode = .interactive
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackground
    
    configLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    defaultNavigationConfig()
    let attribute = [NSAttributedString.Key.foregroundColor: pagePrimaryColor]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
    tableView.reloadData()
    super.viewWillAppear(true)
  }

  #if DEBUG
    @objc func injected() {
      let vc = RemindersViewController()
      vc.pagePrimaryColor = .blue
      homeInject(vc)
    }
  #endif
}

// MARK: - Layout, Gesture setting
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
    let data = viewModel.tasks[indexPath.row]

    if let color = viewModel.primaryColor {
      cell.config(color: color)
    }
    cell.config(data: data)

    // cell to viewModel
    cell.$data
      .compactMap { return $0 }
      .assign(to: \.tasks[indexPath.row], on: viewModel)
      .store(in: &cacnelBag)

    return cell
  }
}

// MARK: - Delegate
extension RemindersViewController {
  override public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let vc = DetailReminderViewController()
    vc.data = viewModel.tasks[indexPath.row]

    navigationController?.present(
      UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
}

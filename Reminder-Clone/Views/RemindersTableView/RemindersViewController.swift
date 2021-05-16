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
  var cancelBag = Set<AnyCancellable>()

  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    viewModel.primaryColor = pagePrimaryColor

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50

    tableView.keyboardDismissMode = .interactive
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackground
    
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
    viewModel.task.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else {
      fatalError("Cell Not Founded")
    }

    cell.color = viewModel.primaryColor ?? .systemBlue
    let data = viewModel.task[indexPath.row]
    cell.textView.text = data.title ?? "New Reminder"
    cell.isDone = data.isDone

    cell.layoutUpdate = { [weak self] in
      self?.tableView.beginUpdates()
      self?.tableView.endUpdates()
    }

    cell.$isDone
      .sink { [weak self] in self?.viewModel.task[indexPath.row].isDone = $0 }
      .store(in: &cancelBag)

    cell.textView.publisher
      .sink { [weak self] in self?.viewModel.task[indexPath.row].title = $0 }
      .store(in: &cancelBag)

    return cell
  }
}

// MARK: - Delegate
extension RemindersViewController {
  override public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let vc = DetailReminderViewController()
//    vc.data = viewModel.task[indexPath.row]

    navigationController?.present(
      UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
}

extension RemindersViewController {
  func configBinding() {
    view.publisher(.tap)
      .sink { [weak self] _ in
        if self?.viewModel.task.last?.title == "" {
          if let count = self?.viewModel.task.count {
            guard let task = self?.viewModel.task.removeLast() else { return }
            self?.tableView.deleteRows(at: [.init(row: count - 1, section: 0)], with: .fade)
            PersistentManager.shared.delete(task)
          }
        } else {
          let entity = PersistentManager.shared.newEntity(entity: Task.self)
          entity.set(key: .title, value: "")
          if let count = self?.viewModel.task.count {
            self?.viewModel.task.append(entity)
            self?.tableView.insertRows(at: [.init(row: count, section: 0)], with: .fade)
          }
        }
      }
      .store(in: &cancelBag)
  }
}

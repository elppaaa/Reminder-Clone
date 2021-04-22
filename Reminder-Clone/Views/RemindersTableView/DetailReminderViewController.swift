//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit

// TODO: Get from core data

class DetailReminderViewController: UITableViewController {
  // TODO: Get from core data
  var pagePrimaryColor: UIColor = .clear
  let customDataSource = RemindersTableViewModel()
  
  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
    customDataSource.primaryColor = pagePrimaryColor
    tableView.dataSource = customDataSource
    tableView.delegate = customDataSource
    tableView.estimatedRowHeight = 40
    tableView.allowsMultipleSelectionDuringEditing = true
    tableView.keyboardDismissMode = .interactive
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackground
    
    configLayout()
    configClosure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
    defaultNavigationConfig()
    let attribute = [NSAttributedString.Key.foregroundColor: pagePrimaryColor]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
    tableView.reloadData()
    super.viewWillAppear(true)
  }
  
  func configClosure() {
    customDataSource.present = {
      (vc) in
      self.navigationController?.present(vc, animated: true)
    }
  }
  
  #if DEBUG
    @objc func injected() {
      let vc = DetailReminderViewController()
      vc.pagePrimaryColor = .blue
      homeInject(vc)
    }
  #endif
}

// MARK: - Layout, Gesture setting
extension DetailReminderViewController {
  fileprivate func configLayout() {
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
  }
}

//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit

// TODO: Get from core data

class RemindersTableViewController: UITableViewController, ViewControllerConfig {
  // TODO: Get from core data
  var pagePrimaryColor: UIColor = .clear
  let customDataSource = RemindersTableViewModel()

  override func loadView() {
    super.loadView()
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.describe)
    customDataSource.primaryColor = pagePrimaryColor
    tableView.dataSource = customDataSource
    tableView.delegate = customDataSource
    customDataSource.parent = self
    tableView.estimatedRowHeight = 20
    tableView.allowsMultipleSelectionDuringEditing = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackgorund

    configLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    globalVCConfig()
    navigationController?.navigationBar.prefersLargeTitles = true

    let attribute = [NSAttributedString.Key.foregroundColor:pagePrimaryColor]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
    tableView.reloadData()
  }

  #if DEBUG
  @objc func injected() {
    let vc = RemindersTableViewController()
    vc.pagePrimaryColor = .blue
    homeInject(vc)
  }
  #endif
}

// MARK: - Layout, Gesture setting
extension RemindersTableViewController {
  fileprivate func configLayout() {
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
  }
  
}

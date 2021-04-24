//
//  ReminderDetailViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class ReminderDetailViewController: UIViewController {
  let tableView = DetailReminderTableView()
  var viewModel = DetailReminderViewModel()
  var tableViewHeight: NSLayoutConstraint?
  var data: MyTask?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Detail"
    view.backgroundColor = R.Color.applicationBackground
    commonInit()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    defaultNavigationConfig()
    navigationController?.isToolbarHidden = true
  }
  
  func commonInit() {
    tableView.dataSource = viewModel
    tableView.delegate = viewModel
    viewModel._tableView = tableView
    viewModel.delegateVC = self
    
    configLayout()
    configNavigationBar()
  }
  
  fileprivate func configLayout() {
    view.addSubview(tableView)
    tableView.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
}

// MARK: - Navigation Setting
extension ReminderDetailViewController {
  fileprivate func configNavigationBar() {
    title = "Detail"
    let cancelNavigationItem = UIBarButtonItem(
      title: "Cancel", style: .plain, target: self, action: #selector(didLeftNavigationBarButtonClicked))
    let doneNavigationItem = UIBarButtonItem(
      title: "Done", style: .done, target: self, action: #selector(didRightNavigationBarButtonClicked))
    
    navigationItem.leftBarButtonItem = cancelNavigationItem
    navigationItem.rightBarButtonItem = doneNavigationItem
  }
  
  @objc func didLeftNavigationBarButtonClicked() {
    if !isEditing {
      dismiss(animated: true)
    }
  }
  
  @objc func didRightNavigationBarButtonClicked() {
    // TODO: save to core data
    dismiss(animated: true)
  }
  
  @objc func injected() {
    let vc = ReminderDetailViewController()
    homeInject(vc)
  }
}

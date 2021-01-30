//
//  ReminderDetailTableView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

protocol ReminderDetailTableViewDataSourceType: NSObject, UITableViewDataSource { }

class ReminderDetailTableView: UITableView {
  let bindDataSource = ReminderDetailTableViewDataSource()
  weak var viewController: UIViewController?
  
  required init?(coder: NSCoder) {
    fatalError("ERROR WHEN CREATE TABLEVIEW")
  }
  
  override init(frame: CGRect, style: UITableView.Style = .plain) {
    super.init(frame: frame, style: style)
    dataSource = bindDataSource
    backgroundColor = .clear
    configLayout()
  }

  func configLayout() {
//    tableHeaderView = UIView()
//    tableFooterView = UIView()
  }
}

class ReminderDetailTableViewDataSource: NSObject, ReminderDetailTableViewDataSourceType {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
  
}

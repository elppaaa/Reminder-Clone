//
//  ReminderDetailTableView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class ReminderDetailTableView: UITableView {
  let bindDataSource = ReminderDetailTableViewDataSource()
  weak var viewController: UIViewController?
  
  required init?(coder: NSCoder) {
    fatalError("ERROR WHEN CREATE TABLEVIEW")
  }
  
  override init(frame: CGRect, style: UITableView.Style = .grouped) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: style)
    }
    translatesAutoresizingMaskIntoConstraints = false
    dataSource = bindDataSource
    delegate = bindDataSource
    backgroundColor = .clear
    configLayout()
  }

  func configLayout() {
    tableHeaderView = UIView()
    tableFooterView = UIView()
    backgroundColor = .none
  }
  #if DEBUG
  @objc func injected() {
    let vc = ReminderDetailViewController()
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = nil
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = UINavigationController(rootViewController: vc)
  }
  #endif
}

class ReminderDetailTableViewDataSource: NSObject { }
extension ReminderDetailTableViewDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.clipsToBounds = true
    cell.textLabel?.text = "hi"
    return cell
  }
  
}

extension ReminderDetailTableViewDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    UIView()
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    CGFloat(30)
  }
}

class ReminderDetailTableViewCell: UITableViewCell {
  var _data: TaskElement?
  required init?(coder: NSCoder) {
    fatalError("DO NOT USE THIS INITIALIZER")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
  }
}

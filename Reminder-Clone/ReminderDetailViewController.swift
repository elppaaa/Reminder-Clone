//
//  ReminderDetailViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class ReminderDetailViewController: UIViewController {

	let tableView = ReminderDetailTableView()
  var data: MyTask?
  
	override func viewDidLoad() {
		super.viewDidLoad()
    view.backgroundColor = R.Color.applicationBackground
    configLayout()
	}

	func configLayout() {
    view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
}

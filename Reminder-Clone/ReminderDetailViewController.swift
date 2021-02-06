//
//  ReminderDetailViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class ReminderDetailViewController: UIViewController {
	let tableView = ReminderDetailTableView()
  var tableViewHeight: NSLayoutConstraint?
  var observeBag = [NSKeyValueObservation]()
  var data: MyTask?

	override func viewDidLoad() {
		super.viewDidLoad()
    title = "Detail"
    view.backgroundColor = R.Color.applicationBackground
    configLayout()
    configNavigationBar()
	}
  
  override func viewWillAppear(_ animated: Bool) {
    defaultNavigationConfig()
  }

	fileprivate func configLayout() {
    view.addSubview(tableView)
//    tableView.layer.cornerRadius = 20
    tableView.layer.masksToBounds = true

//    tableView.autoresizingMask = .flexibleHeight

		NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
		])
    
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
    tableViewHeight?.isActive = true
    
    observeBag.append(tableView.observe(\.contentSize, options: [.new, .prior]) { (_, changed) in
      if let height = changed.newValue?.height {
        self.tableViewHeight?.constant = max(height, self.view.frame.height)
        self.updateViewConstraints()
      }
    })
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
}

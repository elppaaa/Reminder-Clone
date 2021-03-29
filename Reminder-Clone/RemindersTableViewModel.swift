////  RemindersViewControllerDataSource.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/19.
//

import UIKit

struct MyTask {
  var id: Int
  var title: String
  var isDone: Bool = false
}

class RemindersTableViewModel: NSObject {
  var primaryColor: UIColor?
  var present: ( (_ vc: UINavigationController) -> Void )?

  override init() {
    super.init()
  }

  var tasks: [MyTask] = [
    MyTask(id: 0, title: "title"),
    MyTask(id: 1, title: "one"),
    MyTask(id: 2, title: "two"),
  ]
}

extension RemindersTableViewModel: UITableViewDataSource {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else {
      fatalError("Cell Not Founded")
    }
    let data = tasks[indexPath.row]
    cell.delegate = self
    if let color = primaryColor {
      cell.config(color: color)
    }
    cell.config(data: data)
    return cell
  }
}

extension RemindersTableViewModel: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let vc = ReminderDetailViewController()
    vc.data = tasks[indexPath.row]
    present?(UINavigationController(rootViewController: vc))
  }
}

extension RemindersTableViewModel: RemindersTableViewModelDelegate {
  func changeData(with data: MyTask) {
    if let index = tasks.firstIndex(where: { $0.id == data.id }) {
      tasks[index] = data
    }
  }

}

protocol RemindersTableViewModelDelegate {
  func changeData(with data: MyTask)
//  func pushViewController(with data: MyTask)
}

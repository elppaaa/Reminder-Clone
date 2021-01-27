//
//  RemindersViewControllerDataSource.swift
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

class RemindersTableViewModel: NSObject, UITableViewDataSource {
  unowned var parent: UITableView?
  var primaryColor: UIColor?
  
  override init() {
    super.init()
    NotificationCenter.default.addObserver(self, selector: #selector(updateArray), name: Notification.sendisDone, object: nil)
  }

  var tasks: [MyTask] = [
    MyTask(id: 0, title: "title"),
    MyTask(id: 1, title: "one"),
    MyTask(id: 2, title: "two"),
  ]
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderTableViewCell.describe, for: indexPath) as? ReminderTableViewCell else {
      fatalError("Cell Not Founded")
    }
    let data = tasks[indexPath.row]
    
    if let color = primaryColor {
      cell.config(color: color)
    }
    
    cell.config(data: data)
    return cell
  }
  
  @objc func updateArray(_ noti: Notification) {
    guard let _data = noti.object as?  MyTask else { return }
    
    if let index = tasks.firstIndex(where: { $0.id == _data.id }) {
      tasks[index] = _data
    }
    parent?.reloadData()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

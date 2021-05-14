////  RemindersViewControllerDataSource.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/19.
//

import UIKit
import Combine

struct MyTask {
  var id: Int
  var title: String
  var isDone: Bool = false
}

class RemindersTableViewModel: NSObject {
  var primaryColor: UIColor?
  var task = [Task]()

  override init() {
    super.init()
    let manager = PersistentManager.shared
    task = manager.fetch(request: Task.fetchRequest()) ?? []
  }
}

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

  override init() {
    super.init()
  }
  
  var tasks = [
    MyTask(id: 0, title: "title"),
    MyTask(id: 1, title: "one"),
    MyTask(id: 2, title: "two"),
  ]
}

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
  let category: Category
  var tasks = [Task]()
  let manager = PersistentManager.shared

  init(category: Category) {
    self.category = category
    super.init()
    if let _data = category.tasks?.allObjects as? [Task] {
      tasks = _data
    }
  }

  func newTask() -> Task {
    let entity = manager.newEntity(entity: Task.self)
    entity.set(key: .title, value: "")
//    entity.category = category
    category.addToTasks(entity)
    tasks.append(entity)
    return entity
  }

  func delete(task: Task) {
//    category.removeFromTasks(task)
    manager.delete(task)
    _ = tasks.drop { $0.objectID == task.objectID }
  }
  
}

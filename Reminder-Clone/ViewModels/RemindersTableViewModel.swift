////  RemindersViewControllerDataSource.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/19.
//

import UIKit
import Combine
import CoreData

struct MyTask {
  var id: Int
  var title: String
  var isDone: Bool = false
}

class RemindersTableViewModel: NSObject {
  let manager = PersistentManager.shared

  let category: Category
  var tasks = [Task]()
  var tasksCancelBag = [NSManagedObjectID: Set<AnyCancellable>]() 

  init(category: Category) {
    self.category = category
    super.init()
    if let _data = category.tasks?.allObjects as? [Task] {
      tasks = _data
      _data.forEach { tasksCancelBag[$0.objectID] = Set<AnyCancellable>() }
    }
  }

  func newTask() -> Task {
    let entity = manager.newEntity(entity: Task.self)
    tasks.append(entity)
    tasksCancelBag[entity.objectID] = Set<AnyCancellable>()
    entity.set(key: .title, value: "")
    category.addToTasks(entity)
    return entity
  }

  func delete(index: Int, completion: ((Task) -> Void)? = nil) {
    if tasks.indices.contains(index) {
      let task = tasks.remove(at: index)
      category.removeFromTasks(task)
      tasksCancelBag.removeValue(forKey: task.objectID)
      completion?(task)
      manager.delete(task)
    } else {
      print("index out of range")
    }
  }

  func index(of task: Task) -> Int? {
    tasks.firstIndex(where: { $0.objectID == task.objectID }) 
  }

}

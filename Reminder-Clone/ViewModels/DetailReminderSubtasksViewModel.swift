//
//  DetailReminderSubtasksViewModel.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/22.
//

import Foundation
import CoreData.NSManagedObjectID
import UIKit.UIColor
import Combine

class DetailReminderSubtasksViewModel: NSObject {
  init(parent task: Task) {
    parentTask = task
    guard let result = task.subtasks?.allObjects as? [Task] else { assert(false, "Entity not founded"); return }
    
    data = result
  }
  
  var tasksCancelBag = [NSManagedObjectID: Set<AnyCancellable>]()
  
  subscript(_ index: Int) -> Task { data[index] }
  
  fileprivate var data = [Task]()
  fileprivate var parentTask: Task
  
  var count: Int { data.count }
  var isLastEmpty: Bool { data.last?.title == "" }
  var color: UIColor { parentTask.category.color }
  
  func newTask(index: Int) -> Task {
    let entity = PersistentManager.shared.newEntity(entity: Task.self)
    if data.indices.contains(index) {
      data.insert(entity, at: index)
    } else {
      data.append(entity)
    }
    tasksCancelBag[entity.objectID] = Set<AnyCancellable>()
    
    entity.set(key: .title, value: "")
    entity.set(key: .category, value: parentTask.category)
    parentTask.addToSubtasks(entity)

    return entity
  }
  
  func delete(index: Int) {
    if data.indices.contains(index) {
      let task = data.remove(at: index)
      tasksCancelBag.removeValue(forKey: task.objectID)
      parentTask.removeFromSubtasks(task)
      PersistentManager.shared.delete(task)
    } else {
      print("Index out of range")
    }
  }
  
}

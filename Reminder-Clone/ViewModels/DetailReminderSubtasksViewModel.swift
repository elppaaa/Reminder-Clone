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
    guard let result = task.subtasks?.array as? [Task] else { assert(false, "Entity not founded"); return }

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
    let entity = PersistentManager.shared.newTask()
    if data.indices.contains(index) {
      data.insert(entity, at: index)
    } else {
      data.append(entity)
    }
    tasksCancelBag[entity.objectID] = Set<AnyCancellable>()
    
    entity.set(key: .category, value: parentTask.category)
    parentTask.addToSubtasks(entity)

    return entity
  }

  func delete(id: NSManagedObjectID, completionHandler: @escaping ((Int) -> Void) ) {
    guard let _index = index(of: id) else { return }

    let task = data.remove(at: _index)
    DispatchQueue.main.async {
      completionHandler(_index)
    }
    tasksCancelBag.removeValue(forKey: id)
    parentTask.removeFromSubtasks(task)
    PersistentManager.shared.delete(task)
  }

  func index(of id: NSManagedObjectID) -> Int? {
    data.firstIndex(where: { $0.objectID == id })
  }
  
}

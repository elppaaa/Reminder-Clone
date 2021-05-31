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
  var cancelBag = Set<AnyCancellable>()
  
  init(category: Category) {
    self.category = category
    super.init()
    reload()
    configBinding()
  }
  
  func reload() {
    if let _data = category.tasks?.allObjects as? [Task] {
      tasksCancelBag.removeAll()
      if category.isShownCompleted {
        tasks = _data
      } else {
        tasks = _data.filter { $0.isDone == false }
      }
      _data.forEach { tasksCancelBag[$0.objectID] = Set<AnyCancellable>() }
    }
  }
  
  func isLast(id: NSManagedObjectID) -> Bool {
    if let last = tasks.last, last.objectID == id {
      return true
    }
    return false
  }
  
  func newTask(index: Int, handler: @escaping () -> Void) {
    let entity = manager.newEntity(entity: Task.self)
    tasksCancelBag[entity.objectID] = Set<AnyCancellable>()
    entity.set(key: .title, value: "")
    entity.set(key: .category, value: category)
    
    tasks.insert(entity, at: index)
    DispatchQueue.main.async {
      handler()
    }
  }
  
  func hide(id objectID: NSManagedObjectID, completion: @escaping (Int) -> Void) {
    guard let index = index(of: objectID) else { return }
    _ = tasks.remove(at: index)
    tasksCancelBag.removeValue(forKey: objectID)
    DispatchQueue.main.async {
      completion(index)
    }
    manager.saveContext()
  }
  
  func delete(id objectID: NSManagedObjectID, completion: @escaping (Int) -> Void) {
    guard let index = index(of: objectID) else { return }
    let task = tasks.remove(at: index)
    tasksCancelBag.removeValue(forKey: objectID)
    DispatchQueue.main.async {
      completion(index)
    }
    manager.delete(task)
    manager.saveContext()
  }
  
  func index(of objectID: NSManagedObjectID) -> Int? {
    tasks.firstIndex(where: { $0.objectID == objectID })
  }
  
  func index(of task: Task) -> Int? {
    tasks.firstIndex(where: { $0.objectID == task.objectID }) 
  }
  
  func configBinding() {
    category.publisher(for: \.isShownCompleted)
      .sink { _ in
        NotificationCenter.default.post(name: .CategoryChanged, object: self.category)
      }
      .store(in: &cancelBag)
  }
}

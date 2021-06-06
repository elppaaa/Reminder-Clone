////  RemindersViewControllerDataSource.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/19.
//

import UIKit
import Combine
import CoreData

class RemindersTableViewModel: NSObject {
  let manager = PersistentManager.shared
  
  let category: Category
  var tasks: [Task] { category.computedTasks?.array as? [Task] ?? [] }
  var tasksCancelBag = [NSManagedObjectID: Set<AnyCancellable>]()
  var cancelBag = Set<AnyCancellable>()
  
  lazy var tasksPredicate = NSPredicate(format: "category == %@", category)
  lazy var notDonePredicate = NSPredicate(format: "isDone == false")
  lazy var notChildTaskPredicate = NSPredicate(format: "parent == nil")
  
  init(category: Category) {
    self.category = category
    super.init()
    reload()
    configBinding()
  }

  deinit { save() }

  func save() {
    manager.saveContext()
  }
  
  func reload() {
//    tasks = category.computedTasks?.array as? [Task] ?? []
    tasksCancelBag.removeAll()
    tasks.forEach { tasksCancelBag[$0.objectID] = Set<AnyCancellable>() }
  }
  
  func isLast(id: NSManagedObjectID) -> Bool {
    if let last = tasks.last, last.objectID == id {
      return true
    }
    return false
  }
  
  func newTask(index: Int, handler: @escaping () -> Void) {
    let entity = manager.newTask()
    tasksCancelBag[entity.objectID] = Set<AnyCancellable>()
    category.insertIntoTasks(entity, at: index)
    DispatchQueue.main.async {
      handler()
    }
  }

  func move(from: Int, to: Int) {
    guard let entity = category.tasks[from] as? Task else { return }
    category.removeFromTasks(at: from)
    category.insertIntoTasks(entity, at: to)
  }
  
  func hide(id objectID: NSManagedObjectID, completion: @escaping (Int) -> Void) {
    guard let index = index(of: objectID) else { return }

    tasksCancelBag.removeValue(forKey: objectID)
    DispatchQueue.main.async {
      completion(index)
    }
    save()
  }
  
  func delete(id objectID: NSManagedObjectID, completion: @escaping (Int) -> Void) {
    guard let index = index(of: objectID),
          let task = category.tasks[index] as? Task else { return }
//    let task = tasks.remove(at: index)
    tasksCancelBag.removeValue(forKey: objectID)
    DispatchQueue.main.async {
      completion(index)
    }
    manager.delete(task)
    save()
  }
  
  func subTasksIndexPaths(_ task: Task) -> [IndexPath] {
		task.subtasks?
      .compactMap { $0 as? Task }
      .compactMap { index(of: $0.objectID) }
      .map { IndexPath(row: $0, section: 0) }
    ?? []
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

// MARK: - setSubTask
extension RemindersTableViewModel {
	func setSubtasks(parent: IndexPath, child: IndexPath) {
    tasks[child.row].setValue(nil, forKey: TaskAttributesKey.subtasks.rawValue)
    tasks[parent.row].addToSubtasks(tasks[child.row])
  }
}

extension RemindersTableViewModel {
  func deleteCategory() {
    DispatchQueue.global().sync { [weak self] in
      guard let cateogry = self?.category else { return }
      let manager = PersistentManager.shared
      cateogry.tasks
        .compactMap { $0 as? Task }
        .forEach { manager.delete($0) }
      manager.deleteAndSave(cateogry)
    }
  }
}

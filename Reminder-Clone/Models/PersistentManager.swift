//
// Created by JK on 2021/04/16.
//

import UIKit
import CoreData

class PersistentManager {
  static let shared = PersistentManager()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Reminder_Clone")
    container.loadPersistentStores(completionHandler: {
      (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  fileprivate lazy var context: NSManagedObjectContext = persistentContainer.viewContext

  func newCategory() -> Category {
    let count = fetch(request: Category.fetchRequest()).count
    let entity = Category(context: context)
    entity.set(key: .order, value: count)

    return entity
  }

  func newTask() -> Task {
    let entity = Task(context: context)
    entity.set(key: .title, value: "")
    entity.set(key: .createdDate, value: Date())
    return entity
  }
  
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    do {
      let fetchResult = try context.fetch(request)
      return fetchResult
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
  
  func fetch<T: NSManagedObject>(objectID: NSManagedObjectID) -> T? {
    if let entity = context.object(with: objectID) as? T {
      return entity
    }
    return nil
  }

  func delete(_ object: NSManagedObject) {
    context.delete(object)
  }
  
  func deleteAndSave(_ object: NSManagedObject) {
    do {
      context.delete(object)
      try context.save()
    } catch let e{
      assert(false, e.localizedDescription)
    }
  }

  func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) {
    let list = fetch(request: request)
    list.forEach {
      context.delete($0)
    }
    do {
      try context.save()
      NotificationCenter.default.post(name: .CategoryChanged, object: nil)
    } catch {
      return
    }
  }
  
  func edit<T: NSManagedObject>(type entity: T.Type, filter: NSPredicate, result completion: ([T]) -> Void) throws -> Bool {
    let request = entity.fetchRequest()
    request.predicate = filter
    if let fetchResult = try context.fetch(request) as? [T] {
      defer {
        saveContext()
      }
      completion(fetchResult)
      return true
    }
    return false
  }
  
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  func setUndoManager() {
    context.undoManager = UndoManager()
  }

  func unsetUndoManager() {
    context.undoManager = nil
  }

  func rollBack() {
    context.rollback()
  }
}

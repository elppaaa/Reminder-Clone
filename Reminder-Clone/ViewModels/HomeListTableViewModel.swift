//
// Created by JK on 2021/04/23.
//

import UIKit
import Foundation
import Combine
import CoreData.NSManagedObjectID

class HomeListTableViewModel: NSObject {
  static let shared = HomeListTableViewModel()
  
  var data = [Category]() 
  fileprivate var cancelBag = Set<AnyCancellable>()
  let orderSortDescriptor = NSSortDescriptor(key: CategoryAttributeKey.order.rawValue, ascending: true)

  override init() {
    super.init()
    let manager = PersistentManager.shared

    let request: NSFetchRequest<Category> = Category.fetchRequest()
    request.sortDescriptors = [orderSortDescriptor]
    data = manager.fetch(request: request)

    NotificationCenter.default.publisher(for: .CategoryChanged)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .compactMap { _ in manager.fetch(request: Category.fetchRequest()) }
      .assign(to: \.data, on: self)
      .store(in: &cancelBag)
  }

  func deleteCategory(indexPath: IndexPath, handler: @escaping () -> Void) {
    DispatchQueue.global().sync { [weak self] in
      guard let category = self?.data.remove(at: indexPath.row) else { return }
      let manager = PersistentManager.shared

      category.tasks
        .compactMap{ $0 as? Task }
        .forEach { manager.delete($0) }

      DispatchQueue.main.async {
        handler()
      }
      
      manager.delete(category)
      reorder()
    }
  }

  func move(from: Int, to: Int) {
    let category = data.remove(at: from)
    data.insert(category, at: to)

    reorder()
  }

  func reorder() {
    for (i, v) in data.enumerated() {
      v.set(key: .order, value: i)
    }
    save()
  }

  func save() {
    PersistentManager.shared.saveContext()
  }
}

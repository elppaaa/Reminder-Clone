//
// Created by JK on 2021/04/23.
//

import UIKit
import Foundation
import Combine
import CoreData.NSManagedObjectID
import CoreData

class HomeListTableViewModel: NSObject {
  static let shared = HomeListTableViewModel()
  
  var data = [Category]()
  fileprivate var cancelBag = Set<AnyCancellable>()
  let defaultFetchReqeust: NSFetchRequest<Category> = {
    let orderSortDescriptor = NSSortDescriptor(key: CategoryAttributeKey.order.rawValue, ascending: true)
    let request: NSFetchRequest<Category> = Category.fetchRequest()
    request.sortDescriptors = [orderSortDescriptor]
    return request
  }()

  override init() {
    super.init()
    let manager = PersistentManager.shared

    data = manager.fetch(request: defaultFetchReqeust)

    NotificationCenter.default.publisher(for: .CategoryChanged, object: nil)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .compactMap { [weak self] _ in
        guard let request = self?.defaultFetchReqeust else { return nil }
        return manager.fetch(request: request)
      }
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
      manager.delete(category)

      DispatchQueue.main.async {
        handler()
      }
      
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

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

  override init() {
    super.init()
    let manager = PersistentManager.shared

    data = manager.fetch(request: Category.fetchRequest())

    NotificationCenter.default.publisher(for: .CategoryChanged)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .compactMap { _ in manager.fetch(request: Category.fetchRequest()) }
      .assign(to: \.data, on: self)
      .store(in: &cancelBag)
  }

  func deleteCategory(indexPath: IndexPath, handler: @escaping () -> Void) {
    DispatchQueue.global().sync {
      let manager = PersistentManager.shared
      let category = data.remove(at: indexPath.row)
      category.tasks
        .compactMap{ $0 as? Task }
        .forEach { manager.delete($0) }
      manager.delete(category)

      DispatchQueue.main.async {
        handler()
      }

      manager.saveContext()
    }
  }
}

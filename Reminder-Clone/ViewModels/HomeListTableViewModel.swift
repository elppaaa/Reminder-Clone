//
// Created by JK on 2021/04/23.
//

import UIKit
import Foundation
import Combine

class HomeListTableViewModel: NSObject {
  static let shared = HomeListTableViewModel()
  
  var data = [Category]()
  fileprivate var cancelBag = Set<AnyCancellable>()

  override init() {
    super.init()
    let manager = PersistentManager.shared

    data = manager.fetch(request: Category.fetchRequest()) ?? []

    NotificationCenter.default.publisher(for: .CategoryChanged)
      .receive(on: DispatchQueue.global())
      .compactMap { _ in manager.fetch(request: Category.fetchRequest()) }
      .assign(to: \.data, on: self)
      .store(in: &cancelBag)
  }

  func changeCategory(task: Task, category: Category) {
    let prev = task.category
    prev?.removeFromTasks(task)
    category.addToTasks(task)
  }
}

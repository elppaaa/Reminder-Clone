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
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .compactMap { _ in manager.fetch(request: Category.fetchRequest()) }
      .assign(to: \.data, on: self)
      .store(in: &cancelBag)
  }

  func changeCategory(task: Task, category: Category) {
    task.set(key: .category, value: category)
    NotificationCenter.default.post(name: .TaskChanged, object: task)
    NotificationCenter.default.post(name: .CategoryChanged, object: category)
  }
}

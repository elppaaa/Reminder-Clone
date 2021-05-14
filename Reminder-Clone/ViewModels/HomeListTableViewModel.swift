//
// Created by JK on 2021/04/23.
//

import UIKit
import Foundation
import Combine

class HomeListTableViewModel: NSObject {
  var data = [Category]()
  var cancelBag = Set<AnyCancellable>()

  override init() {
    super.init()
    let manager = PersistentManager.shared

    data = manager.fetch(request: Category.fetchRequest()) ?? []

    NotificationCenter.default.publisher(for: .CategoryChanged)
      .compactMap { _ in manager.fetch(request: Category.fetchRequest()) }
      .assign(to: \.data, on: self)
      .store(in: &cancelBag)
  }
}

//
// Created by JK on 2021/03/27.
//

import Foundation

extension NSObject {
  static var identifier: String {
    String(describing: self)
  }
}

//
// Created by JK on 2021/03/31.
//

import UIKit

extension MutableCollection where Index == Int, Iterator.Element: MutableCollection, Iterator.Element.Index == Int {
  subscript(indexPath: IndexPath) -> Iterator.Element.Iterator.Element {
    get {
      self[indexPath.section][indexPath.row]
    }
    set {
      self[indexPath.section][indexPath.row] = newValue
    }
  }
  
  subscript(indexPath: IndexPath, offset: Int) -> Iterator.Element.Iterator.Element {
    get {
      self[indexPath.section][indexPath.row + offset]
    }
    set {
      self[indexPath.section][indexPath.row + offset] = newValue
    }
  }
}

//
//  NSLayoutConstraint+Chain.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/20.
//

import UIKit

extension NSLayoutConstraint {
  func priority(_ priority: UILayoutPriority) -> Self {
    self.priority = priority
    return self
  }
}

//
// Created by JK on 2021/01/10.
//

import UIKit

extension UIView {
  func pin(parent: UIView) {
    parent.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: parent.topAnchor),
      bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      trailingAnchor.constraint(equalTo: parent.trailingAnchor),
    ])
  }
}

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

  func pin(safe parent: UIView, margin: CGFloat = 0) {
    parent.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: margin),
      bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: margin * -1),
      leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: margin),
      trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: margin * -1),
    ])
  }
}

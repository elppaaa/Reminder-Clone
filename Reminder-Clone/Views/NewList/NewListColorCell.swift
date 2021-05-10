//
//  NewListColorCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/11.
//

import UIKit
import Combine

class NewListColorCell: UICollectionViewCell {
  override var reuseIdentifier: String? { Self.identifier }
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configLayout()
  }

  let colorButton: UIButton = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.bounds.size = CGSize(width: 40, height: 40)
    $0.layer.cornerRadius = $0.frame.height / 2.0
    return $0
  }(UIButton())

  func configLayout() {
    colorButton.pin(parent: contentView)
  }
}

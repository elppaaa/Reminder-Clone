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

  let button: UIView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.bounds.size = CGSize(width: 40, height: 40)
    $0.layer.cornerRadius = $0.frame.height / 2.0
    return $0
  }(UIView())

  let strokeLayer: CALayer = {
    let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -5, y: -5), size: CGSize(width: 50, height: 50)))
    $0.path = path.cgPath
    $0.strokeColor = UIColor.systemGray2.cgColor
    $0.lineWidth = 3
    $0.fillColor = .none
    return $0
  }(CAShapeLayer())

  func configLayout() {
    button.pin(safe: contentView)

    button.layer.addSublayer(strokeLayer)
    strokeLayer.isHidden = true
  }
}

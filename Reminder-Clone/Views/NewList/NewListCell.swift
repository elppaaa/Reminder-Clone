//
//  NewListColorCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/11.
//

import UIKit

class NewListCell: UICollectionViewCell {
  override var reuseIdentifier: String? { Self.identifier }
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configLayout()
  }

  lazy var icon: UIImageView = {
    let size = bounds.width
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .center
    $0.preferredSymbolConfiguration = .init(pointSize: size * 0.5)
    $0.tintColor = .darkGray
    $0.backgroundColor = .none
    $0.sizeToFit()
    $0.pin(parent: contentView)
    return $0
  }(UIImageView())

  lazy var backgroundCircle: CAShapeLayer = {
    let size = bounds.width
    let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    $0.path = path.cgPath
    $0.filters = .none
    return $0
  }(CAShapeLayer())

  lazy var strokeLayer: CALayer = {
    let size = bounds.width
    let path = UIBezierPath(
      ovalIn: CGRect(origin: CGPoint(x: -5, y: -5), size: CGSize(width: size + 10, height: size + 10)))
    $0.path = path.cgPath
    $0.strokeColor = UIColor.systemGray2.cgColor
    $0.lineWidth = 3
    $0.fillColor = .none
    return $0
  }(CAShapeLayer())

  func configLayout() {
    layer.addSublayer(strokeLayer)
    layer.addSublayer(backgroundCircle)
    strokeLayer.isHidden = true
  }
}

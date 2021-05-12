//
//  IconImageView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/12.
//

import UIKit

class CircleView: UIView {
  lazy var imageView: UIImageView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .center
    $0.preferredSymbolConfiguration = .init(pointSize: bounds.height * 0.5)
    $0.backgroundColor = .none
    $0.tintColor = .white
    $0.sizeToFit()

    $0.pin(parent: self)
    return $0
  }(UIImageView())

  lazy var circleLayer: CAShapeLayer = {
    let path = UIBezierPath(
      ovalIn: CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.height)))

    $0.path = path.cgPath
    $0.fillColor = .none
    $0.zPosition = -10

    layer.addSublayer($0)
    return $0
  }(CAShapeLayer())

  func setBackground(_ color: UIColor) {
    circleLayer.fillColor = color.cgColor
  }

  func setImage(_ image: UIImage, tint: UIColor = .white) {
    imageView.image = image
    imageView.tintColor = tint
  }

}

//
//  IconImageView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/12.
//

import UIKit

class CircleView: UIView {
  override var translatesAutoresizingMaskIntoConstraints: Bool {
    didSet {
      if !translatesAutoresizingMaskIntoConstraints {
        widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
      }
    }
  }

  lazy var imageView: UIImageView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.pin(safe: self)
    $0.contentMode = .center
    $0.preferredSymbolConfiguration = .init(pointSize: bounds.height * 0.5)
    $0.backgroundColor = .none
    $0.tintColor = .white
    $0.sizeToFit()

    return $0
  }(UIImageView())

  lazy var circleLayer: CAShapeLayer = {
    let path = UIBezierPath(ovalIn: bounds).cgPath
    $0.fillColor = .none
    $0.path = path

    $0.fillColor = .none
    $0.zPosition = -10

    layer.addSublayer($0)
    return $0
  }(CAShapeLayer())

  func setBackground(_ color: UIColor) {
    circleLayer.fillColor = color.cgColor
  }

  func setImage(_ image: UIImage?, tint: UIColor = .white) {
    imageView.image = image
    imageView.tintColor = tint
  }

  func setImage(string: String, tint: UIColor = .white) {
    imageView.image = UIImage(systemName: string)
    imageView.tintColor = tint
  }

}

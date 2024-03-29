//
//  NewListViewControllerHeader.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/09.
//

import UIKit

class ListSettingViewControllerHeader: UICollectionReusableView {
  override var reuseIdentifier: String? { Self.identifier }
  fileprivate let iconSize: CGFloat = 150
  
  var text: String? {
    get { textField.text }
    set { textField.text = newValue }
  }

  var imageText: String = "" {
    didSet {
      icon.setImage(UIImage(systemName: imageText))
    }
  }

  var color: UIColor? {
    get {
      guard let color = icon.circleLayer.fillColor else { return .white }
      return UIColor(cgColor: color)
    }
    set {
      icon.circleLayer.fillColor = newValue?.cgColor
      textField.textColor = newValue
    }
  }

  var iconImage: UIImage? {
    get { icon.imageView.image }
    set { icon.setImage(newValue ?? UIImage()) }
  }

  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configLayout()
  }

  fileprivate let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .equalCentering
    stack.alignment = .center
    stack.spacing = 30
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    return stack
  }()

  lazy var icon = CircleView(frame: CGRect(origin: .zero, size: CGSize(width: iconSize, height: iconSize)))

  let textField: UITextField = {
    let text = UITextField()
    text.sizeToFit()
    text.translatesAutoresizingMaskIntoConstraints = false
    text.backgroundColor = .systemGray5
    text.font = .preferredFont(forTextStyle: .title1)
    text.textAlignment = .center
    text.layer.cornerRadius = 10
    text.inputView?.layoutMargins = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    return text
  }()

  fileprivate func configLayout() {
    backgroundColor = .white

    addSubview(mainStack)
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
    ])

    mainStack.addArrangedSubview(icon)
    mainStack.addArrangedSubview(textField)

    let fontHeight = UIFont.preferredFont(forTextStyle: .title1).lineHeight

    let iconHeight = icon.heightAnchor.constraint(equalToConstant: iconSize)
    iconHeight.priority = .defaultHigh
    let iconWidth = icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
    iconHeight.priority = .defaultHigh

    icon.sizeToFit()

    NSLayoutConstraint.activate([
      iconHeight,
      iconWidth,
      textField.heightAnchor.constraint(equalToConstant: fontHeight * 1.5),
      textField.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
    ])

  }
}

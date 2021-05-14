//
// Created by JK on 2021/01/09.
//

import UIKit

class MainListCollectionViewCell: UICollectionViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    configLayout()
  }
  
  fileprivate let size: CGFloat = 35.0
  
  fileprivate let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .equalCentering
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    return stack
  }()
  
  fileprivate let stack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .equalCentering
    return stack
  }()

  lazy var icon = CircleView(frame: CGRect(origin: stack.frame.origin, size: CGSize(width: size, height: size)))

  lazy var countLabel: UILabel = UILabel.makeView(font: .systemFont(ofSize: (size * 0.8), weight: .bold))
  
  lazy var titleLabel: UILabel = UILabel.makeView(color: .gray, font: .systemFont(ofSize: (size * 0.5), weight: .semibold))
  
  // MARK: - configureLayout
  fileprivate func configLayout() {
    backgroundColor = R.Color.systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = false
    layer.cornerRadius = 10
    layoutMargins = .zero
    
    stack.addArrangedSubview(icon)
    stack.addArrangedSubview(countLabel)

    mainStack.addArrangedSubview(stack)
    mainStack.addArrangedSubview(titleLabel)
    addSubview(mainStack)

    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: topAnchor),
      mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
      mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    
  }

  func configCell(with data: HomeRadiusList) {
    titleLabel.text = data.title
    countLabel.text = "\(data.count)"
    icon.setImage(data.icon)
    icon.setBackground(data.color)
  }

  func config(data: Category) {
    titleLabel.text = data.name
    countLabel.text = String(data.tasks?.count ?? 0)
    icon.setImage(UIImage(systemName: data.icon ?? R.Image.listBullet.rawValue) ?? UIImage())
    icon.setBackground(UIColor(hex: Int(data.color)))
  }
}

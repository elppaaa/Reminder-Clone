//
//  HomeListTableCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/04/23.
//

import UIKit

class MainListTableViewCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String? = nil) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    configLayout()
  }

  fileprivate let iconRate: CGFloat = 0.8
  fileprivate let insetWidth: CGFloat = 8

  lazy var icon = CircleView( frame: CGRect(origin: bounds.origin, size: CGSize(width: contentView.frame.height * iconRate, height: contentView.frame.height * iconRate)))

  lazy var text = UILabel.makeView(color: .label, font: .preferredFont(forTextStyle: .body))
  lazy var detailText = UILabel.makeView(color: .secondaryLabel, font: .preferredFont(forTextStyle: .body))

  fileprivate func configLayout() {
    icon.translatesAutoresizingMaskIntoConstraints = false
    text.translatesAutoresizingMaskIntoConstraints = false
    detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(icon)
    contentView.addSubview(text)
    contentView.addSubview(detailText)

    NSLayoutConstraint.activate([
      icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      detailText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      icon.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: insetWidth),
      text.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: insetWidth),

      detailText.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: insetWidth * -1)
    ])

    text.sizeToFit()
    detailText.sizeToFit()

    separatorInset.left = insetWidth * 2 + icon.bounds.width

    accessoryType = .disclosureIndicator
  }

  func config(with data: HomeRadiusList) {
    icon.setImage(data.icon)
    icon.setBackground(data.color)
    text.text = data.title
    detailText.text = String(data.count)
  }

}

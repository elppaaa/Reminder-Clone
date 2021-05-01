//
//  HomeListTableCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/04/23.
//

import UIKit

class HomeListTableCell: UITableViewCell, HomeListCellViewType {
  fileprivate static let size: CGFloat = 35
  
  required init?(coder: NSCoder) {
    fatalError("ERROR")
  }
  
  override init(style: CellStyle, reuseIdentifier _: String? = nil) {
    super.init(style: .value1, reuseIdentifier: Self.identifier)
    configLayout()
  }
  
  var titleLabel = UILabel.makeView(
    font: .systemFont(ofSize: size / 2))
  
  var countLabel = UILabel.makeView(
    color: .gray,
    font: .systemFont(ofSize: size / 2))
  
  var iconView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleToFill
    imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    return imageView
  }()
  
  override func layoutSubviews() {
    frame.size.height = 50
    super.layoutSubviews()
  }
  
  fileprivate func configLayout() {
    backgroundColor = R.Color.systemBackground
    
    accessoryType = .disclosureIndicator
    
    contentView.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)
    contentView.subviews.forEach {
      make in
      make.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 7),
      countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
    ])
    
  }
}

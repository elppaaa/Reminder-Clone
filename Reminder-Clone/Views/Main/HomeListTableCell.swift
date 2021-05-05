//
//  HomeListTableCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/04/23.
//

import UIKit

class HomeListTableCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  override init(style: CellStyle, reuseIdentifier _: String? = nil) {
    super.init(style: .value1, reuseIdentifier: Self.identifier)
    configLayout()
  }
  
  fileprivate func configLayout() {
    backgroundColor = R.Color.systemBackground
    accessoryType = .disclosureIndicator
    
  }
  
  func config(with data: HomeRadiusList) {
    if #available(iOS 13, *) {
      let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
      imageView?.image = data.icon.withConfiguration(config)
    } else {
      imageView?.image = data.icon
    }
    imageView?.tintColor = data.color
    
    textLabel?.text = data.title
    detailTextLabel?.text = String(data.count)
  }
}

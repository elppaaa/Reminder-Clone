//
//  HomeListView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/10.
//

import UIKit

protocol HomeListCellViewType {
	var titleLabel: UILabel { get set }
  var countLabel: UILabel { get set }
  var iconView: UIImageView { get set }

  func configCell(with data: HomeRadiusList)
//  func configLayout()
}

extension HomeListCellViewType  {
  func configCell(with data: HomeRadiusList) {
    titleLabel.text = data.title
    countLabel.text = "\(data.count)"
    iconView.image = data.icon
    iconView.tintColor = data.color
  }
}

protocol HomeListViewType {
}

struct HomeRadiusList {
  let title: String
  let icon: UIImage
  let color: UIColor
  let count: Int
}

//class HomeListCategoryCell: UITableViewCell, HomeListCellViewType {
//  var titleLabel: UILabel
//  var countLabel: UILabel
//  var iconView: UIImageView
//
//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//  }
//
//  func configLayout() {
//
//  }
//}
//

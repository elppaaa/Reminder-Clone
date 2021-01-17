//
// Created by JK on 2021/01/10.
//

import UIKit

class HomeListTableView: UITableView {

}

class HomeListTableCell: UITableViewCell, HomeListCellViewType {

	func configLayout() {

	}

	required init?(coder: NSCoder) {
		fatalError("ERROR")
	}

	var titleLabel = UILabel.makeView(
			font: .systemFont(ofSize: 15, weight: .bold))

	var countLabel = UILabel.makeView(
		color: .gray,	font: .systemFont(ofSize: 10))

	var iconView: UIImageView

}

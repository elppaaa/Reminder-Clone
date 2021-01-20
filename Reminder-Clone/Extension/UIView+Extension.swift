//
// Created by JK on 2021/01/10.
//

import UIKit

extension UILabel {
	static func makeView(_ title: String,
											 color: UIColor = .black,
											 font: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
	) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = color
		label.font = font
		label.text = title
		return label
	}
	static func makeView(color: UIColor = .black,
											 font: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
	) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = color
		label.font = font
		return label
	}
}

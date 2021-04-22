//
// Created by JK on 2021/04/23.
//

import UIKit

extension UILabel {
  static func makeView(_ title: String,
                       color: UIColor = R.Color.label,
                       font: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
  ) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = color
    label.font = font
    label.text = title
    return label
  }
  
  static func makeView(
    color: UIColor = R.Color.label, font: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
  ) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = color
    label.font = font
    return label
  }
}

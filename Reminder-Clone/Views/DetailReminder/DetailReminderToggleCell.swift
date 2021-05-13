//
// Created by JK on 2021/03/19.
//

import UIKit

class DetailReminderToggleCell: DetailReminderViewCellBase {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    commonInit()
  }

  convenience init(
    title: String,
    image: UIImage,
    color: UIColor,
    type: TaskAttributesKey
  ) {
    self.init(style: .subtitle, reuseIdentifier: Self.identifier)
    textLabel?.text = title
    imageView?.backgroundColor = color
    imageView?.image = image.with(color: .white).wrapBox(size: 28.5)
    imageView?.contentMode = .scaleAspectFit
    dataType = type
  }

  let toggle = UISwitch()

  fileprivate func commonInit() {
    accessoryView = toggle
    imageView?.layer.cornerRadius = 7
  }
  
}

//
// Created by JK on 2021/03/19.
//

import UIKit

class DetailReminderToggleCell: DetailReminderViewCellBase {
  let toggle = UISwitch()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  convenience init(
    title: String,
    image: UIImage,
    color: UIColor
  ) {
    self.init(style: .default, reuseIdentifier: Self.describe)
    textLabel?.text = title
    imageView?.image = image
    imageView?.backgroundColor = color
  }
  
  func commonInit() {
    accessoryView = toggle
    imageView?.contentMode = .center
    imageView?.layer.cornerRadius = 5
    imageView?.tintColor = .white
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let size = contentView.frame.height * 0.5
    imageView?.frame.size = .init(width: size, height: size)
  }
}

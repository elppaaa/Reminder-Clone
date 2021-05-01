//
// Created by JK on 2021/05/01.
//

import UIKit

class DetailReminderListViewCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  var data: HomeRadiusList?
  
  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    commonInit()
  }
  
  let customImage: UIImageView = {
    let i = UIImageView()
    i.translatesAutoresizingMaskIntoConstraints = false
    return i
  }()
  
  func commonInit() {
    imageView?.image = UIImage().wrapBox(size: 35)
    guard let imageView = imageView else { return }
    customImage.pin(parent: imageView)
  }
  
  func config(data: HomeRadiusList) {
    customImage.image = data.icon
    customImage.tintColor = data.color
    textLabel?.text = data.title
  }
  
}

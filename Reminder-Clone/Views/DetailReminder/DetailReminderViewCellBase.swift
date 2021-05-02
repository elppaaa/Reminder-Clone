//
// Created by JK on 2021/04/24.
//

import UIKit

class DetailReminderViewCellBase: UITableViewCell {
  var delegate: DetailReminderTableViewDelegate?
  var dataType: TaskAttributesKey?
  
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let minHeight = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 57)
    minHeight.priority = .defaultHigh
    minHeight.isActive = true
  }
  
}

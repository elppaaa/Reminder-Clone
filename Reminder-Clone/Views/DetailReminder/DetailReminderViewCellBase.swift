//
// Created by JK on 2021/04/24.
//

import UIKit

class DetailReminderViewCellBase: UITableViewCell {
  var delegate: DetailReminderViewCellBaseDelegate?
  var dataType: TaskAttributesKey?
  
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 57)
      .priority(.defaultHigh)
      .isActive = true
  }
  
}

protocol DetailReminderViewCellBaseDelegate {
  func updateLayout(_ handler: (() -> Void)?)
}

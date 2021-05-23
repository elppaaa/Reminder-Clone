//
//  DetailReminderDateCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/03/18.
//

import UIKit

class DetailReminderDateCell: DetailReminderViewCellBase {
  let datePicker: UIDatePicker = {
    let p = UIDatePicker()
    p.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 14.0, *) {
      p.preferredDatePickerStyle = .inline
    }
    p.sizeToFit()
    return p
  }()
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    commonInit()
  }
  
  init(isTimePicker: Bool = false, type: TaskAttributesKey) {
    datePicker.datePickerMode = isTimePicker ? .time : .date
    super.init(style: .default, reuseIdentifier: Self.identifier)
    dataType = type
    commonInit()
  }
  
  func commonInit() {
    datePicker.pin(parent: contentView)
  }
}

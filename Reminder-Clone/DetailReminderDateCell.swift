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
//    p.datePickerMode = .date
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
    contentView.addSubview(datePicker)

    NSLayoutConstraint.activate([
      datePicker.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
      datePicker.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
      datePicker.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
      datePicker.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
      datePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      datePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])

    datePicker.addTarget(self, action: #selector(setDate), for: .valueChanged)
  }

  @objc func setDate() {
    if let type = dataType {
      delegate?.setValue(key: type, value: datePicker.date)
    }
  }

}

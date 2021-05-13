//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit
import Combine

class ReminderTableViewCell: UITableViewCell {
  var color: UIColor = .clear
  @Published var data: MyTask? = nil {
    didSet {
      title.text = data?.title
      if data?.isDone ?? true {
        title.textColor = .gray
        imageView?.tintColor = color
        imageView?.image = R.Image.largeCircle.image
      } else {
        title.textColor = R.Color.label
        imageView?.tintColor = .gray
        imageView?.image = R.Image.emptyCircle.image
      }
    }
  }
  
  fileprivate let title: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isUserInteractionEnabled = true
    return textField
  }()
  
  fileprivate let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.alignment = .fill
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    configLayout()
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleIsDone)))
    title.addTarget(self, action: #selector(didEditingStatusChanged), for: .editingChanged)
    title.addTarget(self, action: #selector(changeAccessoryType), for: .allEditingEvents)
    
  }
  
  fileprivate func configLayout() {
    imageView?.translatesAutoresizingMaskIntoConstraints = true
    imageView?.layoutMargins = .zero
    imageView?.contentMode = .scaleToFill
    contentView.addSubview(title)
    
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(
        equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 10),
      title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
    
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not used Initializer")
  }
  
  func config(color: UIColor) {
    self.color = color
  }
  
  func config(data: MyTask) {
    self.data = data
  }
  
  @objc func toggleIsDone() {
    data?.isDone.toggle()
  }
  
  @objc func didEditingStatusChanged() {
    if let text = title.text {
      data?.title = text
    }
  }

  @objc func changeAccessoryType() {
    accessoryType = title.isEditing ? .detailButton : .none
  }
}

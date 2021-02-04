//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
  var delegate: RemindersTableViewModelDelegate?
  var color: UIColor = .clear
  var _data: MyTask? = nil
  var data: MyTask? {
    get {
      if let data = _data {
        return data
      } else {
        fatalError("ERROR")
      }
    }
    set {
      guard let data = newValue else { return }
      title.text = data.title
      if data.isDone {
        title.textColor = .gray
        imageView?.tintColor = color
        imageView?.image = R.ImageAsset.largeCircle.image()
      } else {
        title.textColor = R.Color.label
        imageView?.tintColor = .gray
        imageView?.image = R.ImageAsset.emptyCircle.image()
      }
      title.text = newValue?.title
      _data = newValue
    }
  }

  let title: UITextField = {
    let textfield = UITextField()
    textfield.translatesAutoresizingMaskIntoConstraints = false
    textfield.isUserInteractionEnabled = true
    return textfield
  }()
  
  let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.alignment = .fill
    return stack
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
    configLayout()
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleIsDone)))
    title.addTarget(self, action: #selector(didEditingStatusChanged), for: .editingChanged)
    title.addTarget(self, action: #selector(changeAccessoryType), for: .allEditingEvents)

  }

  func configLayout() {
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
    if let data = data {
      delegate?.changeData(with: data)
    }
  }
  
  @objc func didEditingStatusChanged() {
    updateTitle()
  }
  
  func updateTitle() {
    if let text = title.text {
      data?.title = text
      if let data = data {
        delegate?.changeData(with: data)
      }
    }
  }

  @objc func changeAccessoryType() {
    accessoryType = title.isEditing ? .detailButton : .none
  }
}

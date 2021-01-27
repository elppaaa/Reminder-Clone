//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
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
        toggleImage.tintColor = color
        toggleImage.image = R.Image.largeCircle
      } else {
        title.textColor = .black
        toggleImage.tintColor = .gray
        toggleImage.image = R.Image.emptyCircle
      }
      title.text = newValue?.title
      _data = newValue
    }
  }

  let toggleImage: UIImageView = {
    let image = UIImageView(frame: .init(x: 0, y: 0, width: 30, height: 30))
    image.translatesAutoresizingMaskIntoConstraints = false
    image.clipsToBounds = true
    image.contentMode = .scaleAspectFill
    image.isUserInteractionEnabled = true
    return image
  }()
  
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
    toggleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleIsDone)))
    title.addTarget(self, action: #selector(changedTitleText), for: .editingDidEnd)
    title.addTarget(self, action: #selector(changedTitleText), for: .touchUpOutside)
  }

  func configLayout() {
    contentMode = .scaleToFill

    contentView.addSubview(toggleImage)
    contentView.addSubview(title)

    NSLayoutConstraint.activate([
      toggleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      toggleImage.widthAnchor.constraint(equalToConstant: 30),
      toggleImage.heightAnchor.constraint(equalTo: toggleImage.widthAnchor, multiplier: 1.0),
      
      title.leadingAnchor.constraint(equalTo: toggleImage.trailingAnchor, constant: 10),
      title.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 10),
    ])
    
    contentView.subviews.forEach { (v) in
      v.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
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
    notifyDataChanged()
  }
  
  @objc func changedTitleText() {
    if let text = title.text {
      data?.title = text
      print("📌 Title Text Changed \(text)")
      notifyDataChanged()
    }
  }
  
  func notifyDataChanged() {
    NotificationCenter.default.post(name: Notification.sendisDone, object: data)
  }

  @objc func setDetailAccessory() {
    accessoryType = .none
  }

}

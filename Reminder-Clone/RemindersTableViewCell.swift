//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
  var color: UIColor = .clear
  var data: MyTask? = nil {
    didSet {
      guard let data = data else { return }
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
    
    toggleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifyIndex)))
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
  
  @objc func notifyIndex() {
    NotificationCenter.default.post(name: Notification.sendisDone, object: data)
  }
  
}

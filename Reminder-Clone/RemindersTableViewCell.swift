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
      self.textLabel?.text = data.title
      if data.isDone {
        self.textLabel?.textColor = .gray
        self.imageView?.tintColor = color
        self.imageView?.image = R.Image.largeCircle
      } else {
        self.textLabel?.textColor = .black
        self.imageView?.tintColor = .gray
        self.imageView?.image = R.Image.emptyCircle
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
    imageView?.contentMode = .scaleAspectFill
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifyIndex)))
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

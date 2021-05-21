//
//  UITextView+Publisher.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/11.
//

import UIKit
import Combine

extension UITextView {
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextView.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextView }
      .compactMap(\.text)
      .eraseToAnyPublisher()
  }

  var endEditingPublisher: AnyPublisher<UITextView, Never> {
    NotificationCenter.default
      .publisher(for: UITextView.textDidEndEditingNotification, object: self)
      .compactMap { $0.object as? UITextView }
      .eraseToAnyPublisher()
  }
  
  var beginEditingPublisher: AnyPublisher<UITextView, Never> {
    NotificationCenter.default
    .publisher(for: UITextView.textDidBeginEditingNotification, object: self)
    .compactMap { $0.object as? UITextView }
    .eraseToAnyPublisher()
  }
}

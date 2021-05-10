//
//  UITextView+Publisher.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/11.
//

import UIKit
import Combine

extension UITextView {
  var publisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextView.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextView }
      .compactMap(\.text)
      .eraseToAnyPublisher()
  }
}

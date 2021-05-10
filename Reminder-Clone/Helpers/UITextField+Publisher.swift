//
//  UITextField+Publisher.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/10.
//

import UIKit
import Combine

extension UITextField {
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField }
      .compactMap(\.text)
      .eraseToAnyPublisher()
  }
}

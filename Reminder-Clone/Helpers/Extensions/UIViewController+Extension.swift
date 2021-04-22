//
//  UIViewController+Extension.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/15.
//

import UIKit

extension UIViewController {
  func defaultNavigationConfig() {
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.isToolbarHidden = false
    navigationController?.toolbar.isTranslucent = true
    navigationController?.toolbar.isOpaque = true
    navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    navigationController?.toolbar.barTintColor = self.view.backgroundColor
  }
}

//
//  UIViewController+Extension.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/15.
//

import UIKit

protocol ViewControllerConfig: UIViewController {
  func globalVCConfig()
}

extension ViewControllerConfig {
  func globalVCConfig() {
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.toolbar.backgroundColor = .clear
    navigationController?.isToolbarHidden = false
  }
}

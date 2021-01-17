//
//  UIViewController+Extension.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/15.
//

import UIKit

protocol ViewControllerConfig: UIViewController {
  func globalVCConfig(title: String?)
}

extension ViewControllerConfig {
  func globalVCConfig(title _title: String? = nil) {
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.toolbar.backgroundColor = .clear
    navigationController?.isToolbarHidden = false
    
    if let _title = _title {
      title = _title
      navigationController?.navigationBar.prefersLargeTitles = true
    } else {
      navigationController?.navigationBar.prefersLargeTitles = false
    }
  }
}

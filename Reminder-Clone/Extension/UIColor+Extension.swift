//
//  UIColor+Extension.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/06.
//

import UIKit

public extension UIColor {
  convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
  }
  
  convenience init(hex: Int) {
    self.init(r: (hex & 0xff0000) >> 16, g: (hex & 0xff00) >> 8, b: (hex & 0xff), a: 1)
  }
}

extension NSObject {
	static var describe: String {
    String(describing: self)
  }
}

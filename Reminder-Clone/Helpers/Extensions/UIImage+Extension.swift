//
// Created by JK on 2021/03/27.
//

import UIKit

// swiftlint:disable type_name force_unwrapping
extension UIImage {
  static let largeCircle = UIImage(named: "largecircle.fill.circle")!
  static let emptyCircle = UIImage(named: "circle")!
  static let calendar = UIImage(named: "calendar")!
  static let clock = UIImage(named: "clock.fill")!
  static let location = UIImage(named: "location.fill")!
  static let folderCircle = UIImage(named: "folder.circle.fill")!
  static let calenderCircle = UIImage(named: "calendar.circle.fill")!
  static let trayCircle = UIImage(named: "tray.circle.fill")!
  static let flagCircle = UIImage(named: "flag.circle.fill")!
  static let flag = UIImage(named: "flag.fill")!
}

extension UIImage {
  
  func with(color: UIColor) -> UIImage {
    var image = withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.set()
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  func with(insets: UIEdgeInsets) -> UIImage? {
    let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
      height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)
    
    UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
    defer { UIGraphicsEndImageContext() }
    let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
    self.draw(at: origin)
    
    return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
  }
  
}

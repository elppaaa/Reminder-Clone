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
  
  func wrapBox(size box: CGFloat) -> UIImage? {
    let cgSize = CGSize(width: box, height: box)
    
    UIGraphicsBeginImageContextWithOptions(cgSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    
    let origin = CGPoint(x: (box - size.width) / 2.0 , y: (box - size.height) / 2.0 )
    draw(at: origin)
    return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
  }
}

//
// Created by JK on 2021/03/27.
//

import UIKit

extension UIImage {
  
  func with(color: UIColor) -> UIImage {
    var image = withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.set()
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
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

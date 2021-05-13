//
// Created by JK on 2021/01/09.
//

import UIKit

// swiftlint:disable type_name force_unwrapping
enum R {
  enum Color {
    static let systemBackground = UIColor(named: "systemBackground")!
    static let applicationBackground = UIColor(named: "applicationBackground")!
    static let systemGray6 = UIColor(named: "systemGray6")!
    static let defaultBackground = UIColor(named: "defaultBackground")!
    static let label = UIColor(named: "label")!
    static let lightBlue = UIColor(hex: 0x6AA7F0)
    static let rose = UIColor(hex: 0xD5A9A4)
  }

// swiftlint:disable type_name force_unwrapping
  enum Image: String {
    case largeCircle = "largecircle.fill.circle"
    case emptyCircle = "circle"
    case calendar = "calendar"
    case clock = "clock.fill"
    case location = "location.fill"
    case folderCircle = "folder.circle.fill"
    case folder = "folder.fill"
    case calenderCircle = "calendar.circle.fill"
    case trayCircle = "tray.circle.fill"
    case tray = "tray.fill"
    case flagCircle = "flag.circle.fill"
    case flag = "flag.fill"
    case plusCircle = "plus.circle.fill"
    case circleFill = "circle.fill"
    case listBullet = "list.bullet"
    
    var image: UIImage {
      UIImage(systemName: self.rawValue)!
    }
  }
}

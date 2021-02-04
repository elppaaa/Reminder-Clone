//
// Created by JK on 2021/01/09.
//

import UIKit
// swiftlint:disable type_name force_unwrapping
struct R {
	struct Color {
		static let systemBackground = UIColor(named: "systemBackground")!
		static let applicationBackground = UIColor(named: "applicationBackground")!
		static let systemGray6 = UIColor(named: "systemGray6")!
    static let defaultBackgorund = UIColor(named: "defaultBackground")!
    static let label = UIColor(named: "label")!
	}

  // swiftlint:disable force_unwrapping
//  struct Image {
//    static let largeCircle = UIImage(named: "largecircle.fill.circle")!
//    static let emptyCircle = UIImage(named: "circle")!
//    static let calendar = UIImage(named: "calendar")!
//    static let clock = UIImage(named: "clock.fill")!
//    static let location = UIImage(named: "location.fill")!
//  }
  enum ImageAsset: String {
    case largeCircle = "largecircle.fill.circle"
    case emptyCircle = "circle"
    case calendar = "calendar"
    case clock = "clock.fill"
    case location = "location.fill"
    case folderCircle = "folder.circle.fill"
    case calenderCircle = "calendar.circle.fill"
    case trayCircle = "tray.circle.fill"
    case flagCircle = "flag.circle.fill"
    
    func image() -> UIImage {
      UIImage(named: self.rawValue)!
    }
  }
}

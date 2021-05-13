//
// Created by JK on 2021/04/23.
//

import UIKit

class HomeListTableViewModel: NSObject {
  private(set) var data: [HomeRadiusList] = [
    HomeRadiusList(title: "Today", icon: R.Image.folder.image, color: .systemBlue, count: 5),
    HomeRadiusList(title: "Scheduled", icon: R.Image.calendar.image, color: .red, count: 9),
    HomeRadiusList(title: "All", icon: R.Image.tray.image, color: .gray, count: 8),
    HomeRadiusList(title: "Flagged", icon: R.Image.flag.image, color: .systemOrange, count: 7),
    HomeRadiusList(title: "Flagged", icon: R.Image.flag.image, color: .systemOrange, count: 7),
  ]
}

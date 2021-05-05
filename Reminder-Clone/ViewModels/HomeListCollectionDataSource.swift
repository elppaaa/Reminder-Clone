//
// Created by JK on 2021/01/09.
//

import UIKit

protocol HomeListDataSource: NSObject {
  var data: [HomeRadiusList] { get }
}

class HomeListCollectionDataSource: NSObject, HomeListDataSource {
  var data: [HomeRadiusList] {
    _data
  }
  
  private var _data: [HomeRadiusList] = [
    HomeRadiusList(title: "Today", icon: R.Image.folderCircle.image , color: .systemBlue, count: 5),
    HomeRadiusList(title: "Scheduled", icon: R.Image.calenderCircle.image, color: .red, count: 9),
    HomeRadiusList(title: "All", icon: R.Image.trayCircle.image, color: .gray, count: 8),
    HomeRadiusList(title: "Flagged", icon: R.Image.flagCircle.image, color: .systemOrange, count: 7),
    HomeRadiusList(title: "Flagged", icon: R.Image.flagCircle.image, color: .systemOrange, count: 7),
  ]
  
  required override init() {
    super.init()
  }
  
  #if DEBUG
    @objc func injected() {
      homeInject()
    }
  #endif
}

extension HomeListCollectionDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let customCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeListCollectionViewCell.identifier, for: indexPath) as? HomeListCollectionViewCell {
      let cell = customCell
      let _data = data[indexPath.row]
      customCell.configCell(with: _data)
      return cell
    } else {
      fatalError("ERROR")
    }
  }
}

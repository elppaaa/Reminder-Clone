//
// Created by JK on 2021/01/09.
//

import UIKit

class HomeRadiusListDataSource: NSObject {
	private var newData: [HomeRadiusList]
	required override init() {
		newData = [
			HomeRadiusList(title: "Today", icon: "folder.circle.fill", color: .systemBlue, count: 5),
			HomeRadiusList(title: "Scheduled", icon: "calendar.circle.fill", color: .red, count: 9),
			HomeRadiusList(title: "All", icon: "tray.circle.fill", color: .gray, count: 8),
			HomeRadiusList(title: "Flagged", icon: "flag.circle.fill", color: .systemOrange, count: 7),
//			HomeRadiusList(title: "Flagged", icon: "flag.circle.fill", color: .systemOrange, count: 7),
		]
		super.init()
	}

	#if DEBUG
	@objc func injected() {
		inject()
	}
	#endif
}

extension HomeRadiusListDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		newData.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let customCell = collectionView.dequeueReusableCell (
			withReuseIdentifier: HomeRadiusListCell.describe, for: indexPath) as? HomeRadiusListCell {
			let cell = customCell
			let data = newData[indexPath.row]
			customCell.configCell(with: data)
			return cell
		} else {
			fatalError("ERROR")
		}
	}
}

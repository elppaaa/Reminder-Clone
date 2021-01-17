//
// Created by JK on 2021/01/09.
//

import UIKit

class HomeListCollectionView: UICollectionView {

	let bindDataSource = HomeListCollectionDataSource()

	required init?(coder: NSCoder) {
		let layout = Self.createLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
    delegate = self
		translatesAutoresizingMaskIntoConstraints = false
    autoresizesSubviews = true
		configLayout()
		reloadData()
	}

	init() {
		let layout = Self.createLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
    delegate = self
		translatesAutoresizingMaskIntoConstraints = false
    autoresizesSubviews = true
		configLayout()
		reloadData()
	}
  
	#if DEBUG
	@objc func injected() {
    homeInject()
	}
	#endif
}

extension HomeListCollectionView {
	fileprivate static func createLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 10
		layout.minimumInteritemSpacing = 10
		layout.sectionInset = .zero
		return layout
	}

	fileprivate func configLayout() {
		backgroundColor = .clear
		register(HomeListCollectionViewCell.self, forCellWithReuseIdentifier: HomeListCollectionViewCell.describe)
	}
}

extension HomeListCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let dataSource = collectionView.dataSource as? HomeListCollectionDataSource {
			if dataSource.data.count - 1 == indexPath.row,
				 dataSource.data.count % 2 == 1 {
				return .init(width: 340, height: 85)
			}
		}
		return .init(width: 165, height: 85)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// TODO: - Touch Down Event
		print(indexPath.row)
	}
}

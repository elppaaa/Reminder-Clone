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
		configLayout()
		reloadData()
	}

	init() {
		let layout = Self.createLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
    delegate = self
		translatesAutoresizingMaskIntoConstraints = false
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
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		layout.sectionInset = .zero
		return layout
	}

	fileprivate func configLayout() {
		backgroundColor = .clear
		register(HomeListCollectionViewCell.self, forCellWithReuseIdentifier: HomeListCollectionViewCell.describe)
    scrollIndicatorInsets = .zero
    layoutMargins = .zero
    isScrollEnabled = false
    clipsToBounds = true
	}
}

extension HomeListCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let width = superview?.frame.width else { fatalError("SuperView Not Founded") }
		if let dataSource = collectionView.dataSource as? HomeListCollectionDataSource {
			if dataSource.data.count - 1 == indexPath.row,
				 dataSource.data.count % 2 == 1 {
				return .init(width: width, height: 85)
			}
		}
		return .init(width: (width - 8) / 2, height: 85)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// TODO: - Touch Down Event
		print(indexPath.row)
	}
}

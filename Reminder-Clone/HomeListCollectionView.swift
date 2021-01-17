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
		translatesAutoresizingMaskIntoConstraints = false
    autoresizesSubviews = true
		configLayout()
		reloadData()
	}

	init() {
		let layout = Self.createLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
		translatesAutoresizingMaskIntoConstraints = false
    autoresizesSubviews = true
		configLayout()
		reloadData()
	}
	#if DEBUG
	@objc func injected() {
		inject()
	}
	#endif
}

extension HomeListCollectionView {
	static func createLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 10
		layout.minimumInteritemSpacing = 10
		layout.estimatedItemSize = .init(width: 100, height: 90)
		layout.itemSize = .init(width: 100, height: 90)
		layout.sectionInset = .zero
		return layout
	}
  
	static func newLayout() -> UICollectionViewLayout {
		let c = UICollectionViewLayout()
		return c
	}

	func configLayout() {
		backgroundColor = .clear
		register(HomeListCollectionViewCell.self, forCellWithReuseIdentifier: HomeListCollectionViewCell.describe)
	}
  
}

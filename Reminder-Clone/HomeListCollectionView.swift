//
// Created by JK on 2021/01/09.
//

import UIKit

class HomeListCollectionView: UICollectionView {
	let bindDataSource = HomeListCollectionDataSource()
  @objc dynamic var height: CGFloat {
    frame.height
  }
  // TODO: will delete
	required init?(coder: NSCoder) {
    let layout = FlowLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
    delegate = layout
		translatesAutoresizingMaskIntoConstraints = false
		configLayout()
	}
  
	init() {
    let layout = FlowLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		dataSource = bindDataSource
    delegate = layout
    configLayout()
		translatesAutoresizingMaskIntoConstraints = false
	}
  
  fileprivate func configLayout() {
    backgroundColor = .clear
    register(HomeListCollectionViewCell.self, forCellWithReuseIdentifier: HomeListCollectionViewCell.describe)
    scrollIndicatorInsets = .zero
    layoutMargins = .zero
//    isScrollEnabled = false
    isScrollEnabled = true
    clipsToBounds = true
  }
  
	#if DEBUG
	@objc func injected() {
    homeInject()
	}
	#endif
}

fileprivate class FlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
  required init?(coder: NSCoder) {
    fatalError("NOT USED")
  }
  
  override init() {
    super.init()
    estimatedItemSize = .zero
    minimumLineSpacing = 8
    minimumInteritemSpacing = 8
    sectionInset = .zero
  }

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   let size = collectionView.layoutMarginsGuide.layoutFrame.size
        if let dataSource = collectionView.dataSource as? HomeListCollectionDataSource {
          if dataSource.data.count - 1 == indexPath.row,
             dataSource.data.count % 2 == 1 {
            return .init(width: size.width , height: 85)
          }
        }
    return .init(width: (size.width - 8) / 2, height: 85)
  }
}

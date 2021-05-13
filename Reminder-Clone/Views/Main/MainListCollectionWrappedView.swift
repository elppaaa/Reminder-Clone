//
// Created by JK on 2021/04/23.
//

import UIKit

class MainListCollectionWrappedView: UIView {
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  fileprivate var observeBag = [NSKeyValueObservation]()

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this Initializer")
  }
  
  fileprivate func commonInit() {
    backgroundColor = R.Color.systemGray6
    layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    
    collectionView.backgroundColor = .clear
    collectionView.scrollIndicatorInsets = .zero
    collectionView.layoutMargins = .zero
    collectionView.isScrollEnabled = false
    collectionView.clipsToBounds = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
    ])

    observeBag.append(collectionView.observe(\.contentSize, options: [.new, .prior]) {
      [weak self] _, val in
      if let value = val.newValue?.height, value != 0 {
        self?.frame.size.height = value
      }
    })
    
  }
  
  func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = .zero
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 8
    layout.sectionInset = .zero
    return layout
  }
}

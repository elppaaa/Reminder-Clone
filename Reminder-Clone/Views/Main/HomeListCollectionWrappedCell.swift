//
// Created by JK on 2021/04/23.
//

import UIKit

class HomeListCollectionWrappedCell: UIView {
  fileprivate let collection = HomeListCollectionView()
  fileprivate var collectionHeight: NSLayoutConstraint?
  fileprivate var contentHeight: NSLayoutConstraint?
  fileprivate var observeBag = [NSKeyValueObservation]()
  var indexPath: IndexPath?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this Initializer")
  }
  
  fileprivate func commonInit() {
    if #available(iOS 13, *) {
      // same width with UITableView .insetgrouped style
      layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    addSubview(collection)
    NSLayoutConstraint.activate([
      collection.topAnchor.constraint(equalTo: topAnchor),
      collection.bottomAnchor.constraint(equalTo: bottomAnchor),
      collection.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      collection.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
    ])
    backgroundColor = R.Color.systemGray6
    
    observeBag.append(collection.observe(\.contentSize, options: [.new, .prior]) {
      [weak self] _, val in
      if let value = val.newValue?.height, value != 0 {
        self?.frame.size.height = value
      }
    })
    
  }
}

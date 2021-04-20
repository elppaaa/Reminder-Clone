//
// Created by JK on 2021/04/23.
//

import UIKit

class HomeListCollectionWrappedCell: UITableViewCell {
  fileprivate let collection = HomeListCollectionView()
  fileprivate var collectionHeight: NSLayoutConstraint?
  fileprivate var contentHeight: NSLayoutConstraint?
  fileprivate var observeBag = [NSKeyValueObservation]()
  var parent: UITableView?
  var indexPath: IndexPath?

  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }

  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }

  fileprivate func commonInit() {
    collection.pin(parent: contentView)
    contentView.backgroundColor = R.Color.systemGray6

    observeBag.append(collection.observe(\.contentSize, options: [.new, .prior]) { [weak self] _, val in
      if let value = val.newValue?.height, value != 0,
         let indexPath = self?.indexPath {
        self?.frame.size.height = value
        self?.parent?.reloadRows(at: [indexPath], with: .none)
      }
    })

  }
}

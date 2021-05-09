//
//  NewListViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/08.
//

import UIKit
import Combine

class NewListViewController: UICollectionViewController {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  init() { super.init(collectionViewLayout: Self.createLayout()) }

  override func loadView() {
    super.loadView()

    collectionView.register(TMPCell.self, forCellWithReuseIdentifier: TMPCell.identifier)

    collectionView.register(
      NewListViewControllerHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: NewListViewControllerHeader.identifier)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    collectionView.backgroundColor = .systemGray3

    defaultNavigationConfig()
    navigationController?.navigationBar.shadowImage = UIImage()
    title = "New List"

  }
}

extension NewListViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: TMPCell.identifier, for: indexPath)
  }

  override func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: NewListViewControllerHeader.identifier, for: indexPath)
      return header
    } else {
      return UICollectionReusableView()
    }
  }
}

extension NewListViewController {
  class func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = .init(width: 30, height: 30)
    let width = UIScreen.main.bounds.width
    layout.headerReferenceSize = .init(width: width, height: 250.0)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = .zero
    return layout
  }
}

class TMPCell: UICollectionViewCell {
  override var reuseIdentifier: String? { Self.identifier }
}

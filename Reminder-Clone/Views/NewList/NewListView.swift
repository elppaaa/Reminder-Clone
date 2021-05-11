//
//  NewListView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/11.
//

import UIKit

class NewListView: UIView {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  init() {
    super.init(frame: .zero)
    configLayout()
    registerCells()
  }

  let stack: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    return $0
  }(UIStackView())

  lazy var header = NewListViewControllerHeader()
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

}

// MARK: - layout
extension NewListView {
  func configLayout() {
    backgroundColor = .white
    collectionView.backgroundColor = .white

    stack.translatesAutoresizingMaskIntoConstraints = false
    header.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)
    stack.addArrangedSubview(header)
    stack.addArrangedSubview(collectionView)

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

      header.heightAnchor.constraint(equalToConstant: 300),
    ])
  }
  
  func registerCells() {
    collectionView.register(NewListColorCell.self, forCellWithReuseIdentifier: NewListColorCell.identifier)
  }

  func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = .init(width: 40, height: 40)
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 20
    layout.sectionInset = .init(top: 30, left: 30, bottom: 30, right: 30)
    return layout
  }
}

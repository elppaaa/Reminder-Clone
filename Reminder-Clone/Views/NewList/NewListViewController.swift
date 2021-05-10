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
  private let viewModel = NewListViewModel()
  private var cancelBag = Set<AnyCancellable>()

  override func loadView() {
    super.loadView()

    collectionView.register(
      NewListViewControllerHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: NewListViewControllerHeader.identifier)
    collectionView.register(NewListColorCell.self, forCellWithReuseIdentifier: NewListColorCell.identifier)
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

// MARK: - layout
extension NewListViewController {
  class func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize = .init(width: layout.collectionViewContentSize.width, height: 250.0)

    layout.itemSize = .init(width: 40, height: 40)
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 20
    layout.sectionInset = .init(top: 30, left: 30, bottom: 30, right: 30)
    return layout
  }
}

// MARK: - dataSource
extension NewListViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.colors.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewListColorCell.identifier, for: indexPath) as? NewListColorCell else {
      return UICollectionViewCell()
    }
    cell.colorButton.backgroundColor = viewModel.colors[indexPath.row]
    cell.colorButton
      .publisher(for: .touchUpInside)
      .compactMap { $0.backgroundColor }
      .assign(to: \.headerColor, on: viewModel)
      .store(in: &cancelBag)

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      guard let header = collectionView.dequeueReusableSupplementaryView(
              ofKind: UICollectionView.elementKindSectionHeader,
              withReuseIdentifier: NewListViewControllerHeader.identifier, for: indexPath)
              as? NewListViewControllerHeader else { return UICollectionReusableView() }

      header.textField.textPublisher
        .compactMap { $0 }
        .assign(to: \.headerText, on: viewModel)
        .store(in: &cancelBag)

      viewModel.$headerText
        .map { $0 }
        .assign(to: \.text, on: header.textField)
        .store(in: &cancelBag)

      viewModel.$headerColor
        .map { $0 }
        .assign(to: \.color, on: header)
        .store(in: &cancelBag)

      viewModel.$headerImage
        .map { $0 }
        .assign(to: \.iconImage, on: header)
        .store(in: &cancelBag)

      return header
    }

    return UICollectionReusableView()
  }
}

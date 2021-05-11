//
//  NewListViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/08.
//

import UIKit
import Combine

class NewListViewController: UIViewController {

  private lazy var contentView = NewListView()
  private let viewModel = NewListViewModel()
  private var cancelBag = Set<AnyCancellable>()
  private var selectedColorCell = IndexPath(item: 0, section: 0)

  override func loadView() {
    super.loadView()
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.collectionView.dataSource = self
    contentView.collectionView.delegate = self

    view.backgroundColor = .white

    defaultNavigationConfig()
    navigationController?.navigationBar.shadowImage = UIImage()
    title = "New List"

    binding()
  }
}

// MARK: - dataSource
extension NewListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.colors.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewListColorCell.identifier, for: indexPath) as? NewListColorCell else {
      return UICollectionViewCell()
    }

    cell.button.backgroundColor = viewModel.colors[indexPath.row]
    return cell
  }

}

extension NewListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? NewListColorCell,
          let prevCell = collectionView.cellForItem(at: selectedColorCell) as? NewListColorCell else { return }

    collectionView.performBatchUpdates {
      cell.strokeLayer.isHidden = false
      prevCell.strokeLayer.isHidden = true
    }

    selectedColorCell = indexPath
    viewModel.headerColor = viewModel.colors[indexPath.item]
  }
}

extension NewListViewController {
  func binding() {
    contentView.header.textField.textPublisher
      .compactMap { $0 }
      .assign(to: \.headerText, on: viewModel)
      .store(in: &cancelBag)

    viewModel.$headerText
      .map { $0 }
      .assign(to: \.text, on: contentView.header.textField)
      .store(in: &cancelBag)

    viewModel.$headerColor
      .map { $0 }
      .assign(to: \.color, on: contentView.header)
      .store(in: &cancelBag)

    viewModel.$headerImage
      .map { $0 }
      .assign(to: \.iconImage, on: contentView.header)
      .store(in: &cancelBag)
  }
}

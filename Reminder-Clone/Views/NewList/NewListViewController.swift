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

  override func loadView() {
    super.loadView()
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.collectionView.dataSource = self
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

    cell.colorButton.backgroundColor = viewModel.colors[indexPath.row]
    cell.colorButton
      .publisher(for: .touchUpInside)
      .compactMap { $0.backgroundColor }
      .assign(to: \.headerColor, on: viewModel)
      .store(in: &cancelBag)

    return cell
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

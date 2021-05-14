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
  private var selectedColorCell: IndexPath?
  private var selectedIconCell: IndexPath?

  fileprivate let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
  fileprivate let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)

  override func loadView() {
    super.loadView()
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.collectionView.dataSource = self
    contentView.collectionView.delegate = self

    defaultNavigationConfig()
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

    title = "New List"

    binding()
    
    navigationItem.leftBarButtonItem = cancel
    navigationItem.rightBarButtonItem = done
  }
}

// MARK: - dataSource
extension NewListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
     return viewModel.colors.count
    case 1:
      return viewModel.images.count
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewListCell.identifier, for: indexPath) as? NewListCell else {
      return UICollectionViewCell()
    }

    switch indexPath.section {
    case 0:
      cell.circleImageView.setBackground(viewModel.colors[indexPath.item])
    case 1:
      cell.circleImageView.setImage(string: viewModel.images[indexPath.item], tint: .darkGray)
      cell.circleImageView.setBackground(.systemGray5)
    default:
      assert(false, "section 2 not used")
    }
    return cell
  }
}

extension NewListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let prevIndexPath: IndexPath?

    switch indexPath.section {
    case 0:
      prevIndexPath = selectedColorCell
      selectedColorCell = indexPath
      viewModel.headerColor = viewModel.colors[indexPath.item]
    case 1:
      prevIndexPath = selectedIconCell
      selectedIconCell = indexPath
      viewModel.imageText = viewModel.images[indexPath.item]
    default:
      return
    }

    guard let cell = collectionView.cellForItem(at: indexPath) as? NewListCell else { return }

    if let prev = prevIndexPath,
       let prevCell = collectionView.cellForItem(at: prev) as? NewListCell {
      collectionView.performBatchUpdates {
        cell.strokeLayer.isHidden = false
        prevCell.strokeLayer.isHidden = true
      }
    } else {
      collectionView.performBatchUpdates { cell.strokeLayer.isHidden = false }
    }
  }
}

extension NewListViewController {
  fileprivate func binding() {
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

    viewModel.$imageText
      .map { $0 }
      .assign(to: \.imageText, on: contentView.header)
      .store(in: &cancelBag)

    // Done Button enable
    viewModel.$headerText
      .sink { [weak self] in
        self?.done.isEnabled = $0.count > 0
      }
      .store(in: &cancelBag)
  }
}

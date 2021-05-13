//
// Created by JK on 2021/05/13.
//

import UIKit

// MARK: - CollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let customCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MainListCollectionViewCell.identifier, for: indexPath) as? MainListCollectionViewCell {
      let cell = customCell
      let _data = viewModel.data[indexPath.row]
      customCell.configCell(with: _data)
      return cell
    } else {
      fatalError("ERROR")
    }
  }
}

// MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = collectionView.layoutMarginsGuide.layoutFrame.size
    if viewModel.data.count - 1 == indexPath.row,
       viewModel.data.count % 2 == 1 {
      return .init(width: size.width, height: 85)
    }
    return .init(width: (size.width - 8) / 2, height: 85)
  }
}

//
//  NewListViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/08.
//

import UIKit
import Combine

class ListSettingViewController: UIViewController {
	required init?(coder: NSCoder) { fatalError("Not used") }
	init(with viewModel: ListSettingViewModel) {
		self.viewModel = viewModel
    selectedColorCell = self.viewModel.colorIndex
    selectedIconCell = self.viewModel.iconIndex
    super.init(nibName: nil, bundle: nil)
	}
	
	private lazy var contentView = ListSettingView()
	private let viewModel: ListSettingViewModel
	private var cancelBag = Set<AnyCancellable>()
	private var selectedColorCell: IndexPath
	private var selectedIconCell: IndexPath
	
	fileprivate let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelButtonTapped))
	fileprivate let done = UIBarButtonItem(barButtonSystemItem: .done, target: self,
		action: #selector(didDoneButtonTapped))
	
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
		navigationController?.presentationController?.delegate = self

		binding()
		
		navigationItem.leftBarButtonItem = cancel
		navigationItem.rightBarButtonItem = done
	}

	@objc
	func didDoneButtonTapped() {
		viewModel.save()
		dismiss(animated: true)
	}
}

// MARK: - dataSource
extension ListSettingViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return ListSettingViewModel.colors.count
		case 1:
			return ListSettingViewModel.icons.count
		default:
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ListSettingCell.identifier, for: indexPath) as? ListSettingCell else {
			return UICollectionViewCell()
		}
		
		switch indexPath.section {
		case 0:
			cell.circleImageView.setBackground(ListSettingViewModel.colors[indexPath.item])
			if selectedColorCell == indexPath {
        cell.strokeLayer.isHidden = false
			}
		case 1:
			cell.circleImageView.setImage(string: ListSettingViewModel.icons[indexPath.item], tint: .darkGray)
			cell.circleImageView.setBackground(.systemGray5)
			if selectedIconCell == indexPath {
        cell.strokeLayer.isHidden = false
			}
		default:
			assert(false, "section 2 not used")
		}
		
		return cell
	}
}

extension ListSettingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let prevIndexPath: IndexPath?
		
		switch indexPath.section {
		case 0:
			prevIndexPath = selectedColorCell
			selectedColorCell = indexPath
			viewModel.set(key: .color, value: ListSettingViewModel.colors[indexPath.item].hex)
		case 1:
			prevIndexPath = selectedIconCell
			selectedIconCell = indexPath
			viewModel.set(key: .icon, value: ListSettingViewModel.icons[indexPath.item])
		default:
			return
		}
		
		if let prev = prevIndexPath {
			setSelect(prev, selected: false)
		}
		setSelect(indexPath, selected: true)
	}
	
	func setSelect(_ indexPath: IndexPath, selected: Bool) {
		guard let cell = contentView.collectionView.cellForItem(at: indexPath) as? ListSettingCell else { return }
		contentView.collectionView.performBatchUpdates {
			cell.strokeLayer.isHidden = selected ? false : true
		}
	}
}

extension ListSettingViewController {
	fileprivate func binding() {
		contentView.header.textField.textPublisher
			.receive(on: RunLoop.main)
			.sink { [weak self] in self?.viewModel.set(key: .name, value: $0) }
			.store(in: &cancelBag)
		
		viewModel.category.publisher(for: \.colorInt)
			.receive(on: RunLoop.main)
			.compactMap { UIColor(hex: Int($0)) }
			.assign(to: \.color, on: contentView.header)
			.store(in: &cancelBag)
		
		viewModel.category.publisher(for: \.iconString)
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.assign(to: \.imageText, on: contentView.header)
			.store(in: &cancelBag)
		
		// Done Button enable
		viewModel.category.publisher(for: \.name)
      .receive(on: RunLoop.main)
			.sink { [weak self] in
				self?.done.isEnabled = $0.count > 0
			}
			.store(in: &cancelBag)
		
	}
	
	@objc
	func didCancelButtonTapped() {
		if viewModel.category.hasChanges {
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			let discardAction = UIAlertAction(title: "Discard Changes", style: .destructive) {[weak self] _ in
				self?.dismiss(animated: true, completion: {
					self?.viewModel.rollBack()
					self?.viewModel.unsetUndoManager()
				})
			}
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			alert.addAction(discardAction)
			alert.addAction(cancelAction)
			
			present(alert, animated: true)
		} else {
			dismiss(animated: true, completion: nil)
		}
	}
}

extension ListSettingViewController: UIAdaptivePresentationControllerDelegate {
	public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    !viewModel.category.hasChanges
	}
	
	public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		didCancelButtonTapped()
	}
	
	func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
   viewModel.cancel()
  }
}

//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Tap Gesture Recognizer
extension RemindersViewController {
	func configGesture() {
		let addTaskGesture = UITapGestureRecognizer(target: self, action: #selector(didTableViewTapped))
		addTaskGesture.delegate = self
		tableView.addGestureRecognizer(addTaskGesture)
		
		NotificationCenter.default
			.publisher(for: UIResponder.keyboardWillHideNotification)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.isKeyboardHidden = true
				self?.setBarButtonMore()
			}
			.store(in: &cancelBag)
		
		NotificationCenter.default .publisher(for: UIResponder.keyboardWillShowNotification)
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.isKeyboardHidden = false
				self?.setBarButtonDone()
			}
			.store(in: &cancelBag)
		
	}
	
	@objc
	private func didTableViewTapped() {
		if tableView.isEditing { return }
		if isKeyboardHidden {
			if viewModel.tasks.count == 0 {
				insertTask(index: 0, animate: .none)
			} else {
				guard let id = viewModel.tasks.last?.objectID else { return }
				insertTask(id: id, animate: .none)
			}
		} else {
			tableView.endEditing(false)
		}
	}
}

extension RemindersViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if gestureRecognizer is UITapGestureRecognizer, touch.view == tableView { return true }
		return false
	}
}

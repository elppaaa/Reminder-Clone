//
//  RemindersViewController+UIMenu.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/31.
//

import UIKit

// MARK: - Create Menu/ActionSheet
extension RemindersViewController {
  func setBarButtonDone() {
    navigationItem.rightBarButtonItem =
      UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didDoneButtonTapped))
  }
  
  func setBarButtonMore() {
    if #available(iOS 14.0, *) {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: nil,
        image: UIImage(systemName: "ellipsis.circle"),
        primaryAction: nil,
        menu: UIMenu(children: createMenu()))
    } else {
      navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain,
                        target: self, action: #selector(didMoreBarButtonTapped))
    }
  }
  
  @objc
  private func didDoneButtonTapped() {
    if tableView.isEditing {
      unsetEditingMode()
    } else {
      tableView.endEditing(true)
    }
  }
  
  @objc
  private func didMoreBarButtonTapped() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction( UIAlertAction(title: "Name & Appearance", style: .default,
                                   handler: { [weak self] _ in self?.nameAndAppearanceAction() }) )
    // alert.addAction( UIAlertAction(title: "Share List", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Select Reminders", style: .default,
                                   handler: { [weak self] _ in self?.setEditingMode() }) )
    // alert.addAction( UIAlertAction(title: "Sort By", style: .default, handler: { _ in print("action") }) )
    let isShown = viewModel.category.isShownCompleted
    alert.addAction(UIAlertAction(
                      title: isShown ? "Hide Completed" : "Show Completed",
                      style: .default,
                      handler: { [weak self] _ in self?.viewModel.category.isShownCompleted.toggle() } ))
    alert.addAction( UIAlertAction(title: "Print", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Delete List", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )
    present(alert, animated: true, completion: nil)
  }
  
  func createMenu() -> [UIAction] {
    let nameAppearance = UIAction(title: "Name & Appearance", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in
      self?.nameAndAppearanceAction()
    })
    let selectReminders = UIAction(title: "Select Reminders", image: UIImage(systemName: "checkmark.circle"),
                                   handler: { [weak self] _ in self?.setEditingMode() })
    let sortBy = UIAction(title: "Sort By", image: UIImage(systemName: "arrow.up.arrow.down"),
                          handler: { _ in print("action called") })
    
    let isShown = viewModel.category.isShownCompleted
    let showCompleted = UIAction(
      title: isShown ? "Hide Completed" : "Show Completed",
      image: isShown ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye"),
      handler: { [weak self] _ in self?.viewModel.category.isShownCompleted.toggle() }
    )
    let printer = UIAction(title: "Print", image: UIImage(systemName: "printer"), handler: { _ in print("action called") })
    let delete = UIAction(title: "Delete List", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in print("action called") })
    
    return [nameAppearance, selectReminders, sortBy, showCompleted, printer, delete]
  }
  
}

// MARK: - Menu/ActionSheet Actions
extension RemindersViewController {
  fileprivate func nameAndAppearanceAction() {
    let vc = ListSettingViewController(with: ListSettingViewModel(with: viewModel.category))
    vc.title = "Name & Appearance"
    present(UINavigationController(rootViewController: vc), animated: true)
  }

  fileprivate func setEditingMode() {
    tableView.setEditing(true, animated: true)
    setBarButtonDone()
    isTableViewEditing = true
  }

  fileprivate func unsetEditingMode() {
    tableView.setEditing(false, animated: true)
    setBarButtonMore()
    isTableViewEditing = false
  }

}

//
//  RemindersViewController+UIMenu.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/31.
//

import UIKit

// MARK: - UITabBar Menu
extension RemindersViewController {
  var menus: [UIAction] {
    [
      UIAction(title: "Name & Appearance", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in self?.nameAndAppearanceAction() }),
      UIAction(title: "Share List", image: UIImage(systemName: "person.crop.circle.fill.badge.plus"), handler: { _ in print("action called") }),
      UIAction(title: "Select Reminders", image: UIImage(systemName: "checkmark.circle"), handler: { _ in print("action called") }),
      UIAction(title: "Sort By", image: UIImage(systemName: "arrow.up.arrow.down"), handler: { _ in print("action called") }),
      UIAction(title: "Show Completed", image: UIImage(systemName: "eye"), handler: { _ in print("action called") }),
      UIAction(title: "Print", image: UIImage(systemName: "printer"), handler: { _ in print("action called") }),
      UIAction(title: "Delete List", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in print("action called") }),
    ]
  }
  
  func configTabBar() {
    if #available(iOS 14.0, *) {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: nil,
        image: UIImage(systemName: "ellipsis.circle"),
        primaryAction: nil,
        menu: UIMenu(children: menus))
    } else {
      navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didRightBarButtonTapped))
    }
  }

  @objc
  func didRightBarButtonTapped() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction( UIAlertAction(title: "Name & Appearance", style: .default, handler: { [weak self] _ in self?.nameAndAppearanceAction() }) )
    alert.addAction( UIAlertAction(title: "Share List", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Select Reminders", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Sort By", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Show Completed", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Print", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Delete List", style: .default, handler: { _ in print("action") }) )
    alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )
    present(alert, animated: true, completion: nil)
  }
  
  func nameAndAppearanceAction() {
    let vc = ListSettingViewController(with: ListSettingViewModel(with: viewModel.category))
    vc.title = "Name & Appearance"
    present(UINavigationController(rootViewController: vc), animated: true)
  }
  
}

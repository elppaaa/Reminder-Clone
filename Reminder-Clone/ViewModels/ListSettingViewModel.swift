//
//  NewListViewModel.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/10.
//

import Foundation
import UIKit.UIColor
import Combine

class ListSettingViewModel: NSObject {
  var category: Category

  static let colors: [UIColor] = [ .systemRed, .systemOrange, .systemYellow, .systemGreen, R.Color.lightBlue,
                            .systemBlue, .systemIndigo, .systemPink, .systemPurple, .brown, .darkGray, R.Color.rose]

  static let icons: [String] = ["list.bullet", "bookmark.fill", "mappin", "gift.fill", "graduationcap.fill", "doc.fill", "book.fill", "tray.fill", "creditcard.fill"]
  
  fileprivate let manager = PersistentManager.shared
  fileprivate let isCreated: Bool
  
	// New Category
  override init() {
    category = PersistentManager.shared.newCategory()
    category.set(key: .name, value: "")
    category.set(key: .color, value: Int32(UIColor.systemBlue.hex))
    category.set(key: .icon, value: R.Image.listBullet.rawValue)
    
    isCreated = true
    manager.saveContext()
    manager.setUndoManager()
    super.init()
  }

  init(with category: Category) {
    self.category = category
    manager.saveContext()
    isCreated = false
    super.init()
  }

  deinit {
    manager.unsetUndoManager()
  }
  
	var colorIndex: IndexPath {
    for (i, v) in Self.colors.enumerated() {
      if v.hex == category.colorInt {
        return IndexPath(item: i, section: 0)
      }
    }
    return IndexPath(item: 4, section: 0) // default Color
  }
  
  var iconIndex: IndexPath {
    for (i, v) in Self.icons.enumerated() {
      if v == category.iconString {
        return IndexPath(item: i, section: 1)
      }
    }
    return IndexPath(item: 0, section: 1) // default icon
  }

  func set<T>(key: CategoryAttributeKey, value: T) {
    category.set(key: key, value: value)
  }
  
  func setNil(key: CategoryAttributeKey) {
    category.setValue(nil, forKey: key.rawValue)
  }
  
  func delete() {
    DispatchQueue.global().async { [weak self] in
      if let category = self?.category {
        PersistentManager.shared.deleteAndSave(category)
      }
    }
  }
  
  func cancel() {
    if isCreated {
      delete()
    } else {
      rollBack()
    }
  }
  
  func rollBack() {
    manager.rollBack()
  }
  
  func save() {
    manager.saveContext()
    NotificationCenter.default.post(name: .CategoryChanged, object: category)
  }
	
  func unsetUndoManager() {
    manager.unsetUndoManager()
  }
}

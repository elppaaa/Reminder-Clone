//
//  NewListViewModel.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/10.
//

import Foundation
import UIKit.UIColor
import Combine

class NewListViewModel: NSObject {
  @Published var headerText: String = "" 
  @Published var headerColor: UIColor = UIColor.systemBlue
  @Published var imageText: String = R.Image.listBullet.rawValue

  let colors: [UIColor] = [ .systemRed, .systemOrange, .systemYellow, .systemGreen, R.Color.lightBlue,
                            .systemBlue, .systemIndigo, .systemPink, .systemPurple, .brown, .darkGray, R.Color.rose]

  let images: [String] = [ R.Image.calendar.rawValue, R.Image.clock.rawValue, R.Image.location.rawValue ]

  func save() {
    let manager = PersistentManager.shared

    let entity = manager.newEntity(entity: Category.self)
    entity.set(key: .name, value: headerText)
    entity.set(key: .color, value: headerColor.hex)
    entity.set(key: .icon, value: imageText)

    manager.saveContext()
    NotificationCenter.default.post(name: .CategoryChanged, object: nil)
  }
}

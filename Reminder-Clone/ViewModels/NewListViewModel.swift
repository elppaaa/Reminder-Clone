//
//  NewListViewModel.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/10.
//

import UIKit.UIColor
import Combine

class NewListViewModel: NSObject {
  @Published var headerText: String = "" 
  @Published var headerColor: UIColor = UIColor.systemBlue
  @Published var headerImage: UIImage = R.Image.listBullet.image

  let colors: [UIColor] = [ .systemRed, .systemOrange, .systemYellow, .systemGreen, R.Color.lightBlue,
                            .systemBlue, .systemIndigo, .systemPink, .systemPurple, .brown, .darkGray, R.Color.rose]
}

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
}

//
// Created by JK on 2021/04/25.
//

import UIKit

protocol ViewControllerDelegate: UIViewController {
  func pushVC(_ vc: UIViewController, animated: Bool)
}

extension ViewControllerDelegate {
  func pushVC(_ vc: UIViewController, animated: Bool) {
    self.navigationController?.pushViewController(vc, animated: animated)
  }
}

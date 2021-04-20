//
// Created by JK on 2021/01/10.
//

import UIKit

// TODO: - UITableView 완성할 것.
/*
 UITableView 에서, collapse 고려하여
 stackview, collectionview, tableview 중에서
 어떤 뷰로 표시할 것인지를 고민 후 재 작성 예정.
 */

// MARK: -
class HomeListTableView: UITableView {
  let bindDataSource = HomeListTableViewModel()
  weak var viewController: UIViewController?
  @objc dynamic var height: CGFloat {
    contentSize.height
  }

  required init?(coder: NSCoder) {
    fatalError("ERROR WHEN CREATE TABLEVIEW")
  }

  override init(frame: CGRect, style: Style = .grouped) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: style)
    }
    dataSource = bindDataSource
    delegate = self
    register(HomeListTableCell.self, forCellReuseIdentifier: HomeListTableCell.identifier)
    configLayout()
    reloadData()
  }

  convenience init() {
    self.init(frame: .zero)
    dataSource = bindDataSource
    delegate = self
    register(HomeListTableCell.self, forCellReuseIdentifier: HomeListTableCell.identifier)
    configLayout()
  }

  func configLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .none
    rowHeight = CGFloat(50)
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    isScrollEnabled = false
    tableFooterView = UIView()
  }

  #if DEBUG
  @objc func injected() {
    inject()
  }

  func inject() {
    //change vc
    let vc = ViewController(style: .grouped)
    let navigation = UINavigationController(rootViewController: vc)
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = nil
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = navigation
  }
  #endif

}

extension HomeListTableView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = viewController {
      let data = bindDataSource.data[indexPath.row]
      let reminderVC = RemindersTableViewController()
      reminderVC.pagePrimaryColor = data.color
      reminderVC.title = data.title
      vc.navigationController?.pushViewController(reminderVC, animated: true)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

//
// Created by JK on 2021/04/23.
//

import UIKit

protocol HomeListTableViewModelDelegate: UITableViewController {
  func pushVC(_ vc: UIViewController, animated: Bool)
}

class HomeListTableViewModel: NSObject, HomeListDataSource {
  var observeBag = [NSKeyValueObservation]()
  var data: [HomeRadiusList] {
    _data
  }
  var delegate: HomeListTableViewModelDelegate?

  private var _data: [HomeRadiusList] = [
    HomeRadiusList(title: "Today", icon: .folderCircle, color: .systemBlue, count: 5),
    HomeRadiusList(title: "Scheduled", icon: .calenderCircle, color: .red, count: 9),
    HomeRadiusList(title: "All", icon: .trayCircle, color: .gray, count: 8),
    HomeRadiusList(title: "Flagged", icon: .flagCircle, color: .systemOrange, count: 7),
    HomeRadiusList(title: "Flagged", icon: .flagCircle, color: .systemOrange, count: 7),
  ]
  
}

extension HomeListTableViewModel: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "My Lists"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    section 0
    //    if indexPath.section == 0 {
    //      let cell = HomeListCollectionWrappedCell(style: .default, reuseIdentifier: nil)
    //      cell.indexPath = indexPath
    //      cell.parent = tableView
    //      return cell
    //    }
    
    // section 1
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeListTableCell.identifier, for: indexPath)
            as? HomeListTableCell else {
      fatalError("ERROR WHEN CREATE CELL")
    }
    let data = _data[indexPath.row]
    tableView.beginUpdates()
    cell.configCell(with: data)
    tableView.endUpdates()
    return cell
  }
}

extension HomeListTableViewModel: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = _data[indexPath.row]
    let reminderVC = RemindersTableViewController()
    reminderVC.pagePrimaryColor = data.color
    reminderVC.title = data.title
    delegate?.pushVC(reminderVC, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

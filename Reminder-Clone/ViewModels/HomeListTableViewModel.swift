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
    HomeRadiusList(title: "Today", icon: R.Image.folder.image, color: .systemBlue, count: 5),
    HomeRadiusList(title: "Scheduled", icon: R.Image.calendar.image, color: .red, count: 9),
    HomeRadiusList(title: "All", icon: R.Image.tray.image, color: .gray, count: 8),
    HomeRadiusList(title: "Flagged", icon: R.Image.flag.image, color: .systemOrange, count: 7),
    HomeRadiusList(title: "Flagged", icon: R.Image.flag.image, color: .systemOrange, count: 7),
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeListTableCell.identifier, for: indexPath)
      as? HomeListTableCell else { fatalError("ERROR WHEN CREATE CELL") }
    let data = _data[indexPath.row]

    tableView.performBatchUpdates {
      cell.config(with: data)
    }

    return cell
  }
}

extension HomeListTableViewModel: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = _data[indexPath.row]
    let reminderVC = RemindersViewController()
    reminderVC.pagePrimaryColor = data.color
    reminderVC.title = data.title
    delegate?.pushVC(reminderVC, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

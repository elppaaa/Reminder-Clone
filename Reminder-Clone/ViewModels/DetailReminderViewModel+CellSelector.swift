//
// Created by JK on 2021/03/26.
//

import UIKit

extension DetailReminderViewModel {
  // MARK: -  Cell Selector
  // // TODO: -  Cell 표시 / 숨김 방식 데이터 바인딩 고려하여 재설계
  // TODO: - 코어 데이터에서 값을 받아와 TableView 필요 요소들 채워야 함.
  
  func tableViewCellSelector(indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell
  
    cell = cells[indexPath]
  
    switch (indexPath.section, indexPath.row) {
    case (4, 0):
      cell.textLabel?.text = "Priority"
      cell.detailTextLabel?.text = "None"
      cell.accessoryType = .disclosureIndicator
    case (4, 1):
      cell.textLabel?.text = "List"
      cell.detailTextLabel?.text = "미리 알림"
      cell.accessoryType = .disclosureIndicator
    default:
      break
    }
  
    if let _cell = cell as? DetailReminderViewCellBase {
      _cell.delegate = self
    }
    
    cell.selectionStyle = .none
    
    return cell
  }
  
}
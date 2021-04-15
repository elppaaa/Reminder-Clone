//
// Created by JK on 2021/03/26.
//

import UIKit

class DetailReminderViewCellBase: UITableViewCell {
	var delegate: DetailReminderTableViewDelegate?
	var dataType: TaskAttributesKey?
}

extension DetailReminderViewModel {
	// MARK: -  Cell Selector
	// 셀 화면 표시와 관련된 설정을 표시함.
	// TODO: - 코어 데이터에서 값을 받아와 TableView 필요 요소들 채워야 함.
	// cell placeholder || text , Date 등등

	func tableViewCellSelector(indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell

		cell = cells[indexPath]

		if let _cell = cell as? DetailReminderViewCellBase {
			_cell.delegate = self
		}

		cell.selectionStyle = .none

		return cell
	}
}

//
// Created by JK on 2021/03/26.
//

import UIKit

class DetailReminderViewCellBase: UITableViewCell {
	var delegate: DetailReminderTableViewDelegate?
}

extension DetailReminderViewModel {
	// MARK: -  Cell Selector
	// 셀 화면 표시와 관련된 설정을 표시함.
	func tableViewCellSelector(indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell

		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			cell = DetailReminderInputCell(placeHolder: "Title")
		case (0, 1):
			cell = DetailReminderInputCell(placeHolder: "Notes")
		case (0, 2):
			cell = DetailReminderInputCell(placeHolder: "URL")

		case (1, 0):
			cell = DetailReminderToggleCell(
				title: "Date", image: .calendar, color: .systemRed)
		case (1, 1):
			cell = DetailReminderDateCell()
		case (1, 2):
			cell = DetailReminderToggleCell(
				title: "Time", image: .clock, color: .systemBlue)
		case (1, 3):
			cell = DetailReminderDateCell(isTimePicker: true)

		case (2, 0):
			cell = DetailReminderToggleCell(
				title: "Location", image: .location, color: .systemBlue)

		case (3, 0):
			cell = DetailReminderToggleCell(
			title: "Flag", image: .flag, color: .systemOrange)

		default:
			cell = UITableViewCell()
		}

		if let _cell = cell as? DetailReminderViewCellBase {
			_cell.delegate = self
		}

		cell.selectionStyle = .none

		return cell
	}
}

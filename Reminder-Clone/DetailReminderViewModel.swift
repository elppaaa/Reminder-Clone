//
// Created by JK on 2021/03/19.
//

import UIKit

@objc protocol DetailReminderTableViewDelegate {
	@objc optional var tableView: UITableView? { get }
}

class DetailReminderViewModel: NSObject {
	var _tableView: UITableView?

}

extension DetailReminderViewModel: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		3
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// TODO: will change
		switch section {
		case 0:
			return 3
		case 1:
			return 2
		case 2:
			return 1
		default:
			return 1
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// TODO: will change
		/// row height 별로 switch - case 만들기 vs 2차원 배열사용
		switch indexPath.section {
		case 0:
			let cell = DetailReminderInputCell()
			cell.delegate = self
			return cell

		case 1:
			switch indexPath.row {
			case 0:
				return DetailReminderDateCell(isTimePicker: false)
			case 1:
				return DetailReminderDateCell(isTimePicker: true)
			default:
				return UITableViewCell()
			}

		case 2:
			return DetailReminderToggleCell(
				title: "Date", image: .clock, color: .systemBlue, delegate: self)
		default:
			return UITableViewCell()
		}
	}

}

extension DetailReminderViewModel: UITableViewDelegate { }
extension DetailReminderViewModel: DetailReminderTableViewDelegate {
	var tableView: UITableView? { _tableView }
}

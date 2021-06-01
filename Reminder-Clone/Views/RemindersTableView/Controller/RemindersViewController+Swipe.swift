//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Swipe Action
extension RemindersViewController {
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, result in
			guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell,
						let id = cell.id else { return }
			
			self?.viewModel.delete(id: id) { [weak self] _ in
				self?.tableView.deleteRows(at: [indexPath], with: .fade)
			}
			
			result(true)
		}
		
		let flagAction = UIContextualAction(style: .normal, title: "Flag") { [weak self] _, _, result in
			self?.viewModel.tasks[indexPath.row].flag.toggle()
			result(true)
		}
		flagAction.backgroundColor = .systemOrange
		
		let detailAction = UIContextualAction(style: .normal, title: "Detail") { [weak self] _, _, result in
			self?.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
			result(true)
		}
		
		return UISwipeActionsConfiguration(actions: [deleteAction, flagAction, detailAction])
	}
}

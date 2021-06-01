//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Delegate
extension RemindersViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell else { return }
		if !tableView.isEditing {
			cell.textView.becomeFirstResponder()
		}
	}
	
	override public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		PersistentManager.shared.saveContext()
		let object = viewModel.tasks[indexPath.row]
		if object.title == "" {
			object.set(key: .title, value: "New Reminder")
		}
		
		let vc = DetailReminderViewController(task: object)
		
		navigationController?.present(
			UINavigationController(rootViewController: vc), animated: true, completion: nil)
	}
	
	// move cells
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
	override func tableView(
		_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		viewModel.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
	}
}

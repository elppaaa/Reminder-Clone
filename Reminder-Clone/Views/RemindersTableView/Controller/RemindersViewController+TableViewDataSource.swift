//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - DataSource
extension RemindersViewController {
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.tasks.count
	}
	
	public override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath ) -> Int {
    viewModel.tasks[indexPath.row].parent == nil ? 0 : 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else {
			fatalError("Cell Not Founded")
		}
		cell.color = viewModel.category.color
		
		let data = viewModel.tasks[indexPath.row]
		cell.textView.text = data.title
		cell.isDone = data.isDone
		cell.priority = data.priority
		cell.delegate = self
		cell.id = data.objectID
		viewModel.tasksCancelBag[data.objectID]?.removeAll()
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			data.publisher(for: \.title)
					.receive(on: RunLoop.main)
					.removeDuplicates()
					.sink { cell.textView.text = $0 }
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			cell.$isDone
				.receive(on: RunLoop.main)
				.removeDuplicates()
				.sink { data.set(key: .isDone, value: $0) }
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			cell.textView.textPublisher
				.receive(on: RunLoop.main)
				.removeDuplicates()
				.sink { data.set(key: .title, value: $0) }
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			data.publisher(for: \.flag)
					.receive(on: RunLoop.main)
					.removeDuplicates()
					.assign(to: \.flagVisible, on: cell)
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			data.publisher(for: \.priority)
					.receive(on: RunLoop.main)
					.removeDuplicates()
					.sink { cell.priority = $0 }
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			data.publisher(for: \.isDone)
					.debounce(for: .seconds(3), scheduler: RunLoop.main)
					.filter { $0 }
					.sink { [weak self] _ in self?.hideCell(id: data.objectID) }
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			$isTableViewEditing
				.sink {
				cell.selectionStyle = $0 ? .default : .none
				cell.textView.isUserInteractionEnabled = $0 ? false : true
				cell.toggleButton.isHidden = $0 ? true : false
			}
		)
		
		cell.accessoryType = data.subtasks?.count == 0 ? .none : .disclosureIndicator
		cell.subTasksCountView.isHidden = false
		if let count = data.subtasks?.count, count != 0 {
			cell.subTasksCountView.text = String(count) + " "
		}
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			cell.textView.endEditingPublisher
				.receive(on: RunLoop.main)
				.sink { [weak self] in
					if $0.text == "" { self?.removeCell(id: data.objectID); return }
					cell.accessoryType = data.subtasks?.count == 0 ? .none : .disclosureIndicator
					cell.subTasksCountView.isHidden = false
					if let count = data.subtasks?.count, count != 0 {
						cell.subTasksCountView.text = String(count) + " "
					}
			}
		)
		
		viewModel.tasksCancelBag[data.objectID]?.insert(
			cell.textView.beginEditingPublisher
			.receive(on: RunLoop.main)
			.sink { _ in
				cell.accessoryType = .detailButton
				cell.subTasksCountView.isHidden = true
			}
		)
		
		return cell
	}
}

//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Drag - Drop. move cells
extension RemindersViewController: UITableViewDragDelegate {
  func tableView( _ tableView: UITableView, itemsForBeginning
                    session: UIDragSession, at indexPath: IndexPath ) -> [UIDragItem] {
    let item = UIDragItem(itemProvider: NSItemProvider())
    item.localObject = (indexPath, viewModel.category.tasks[indexPath.row])

    return [item]
  }

}

extension RemindersViewController: UITableViewDropDelegate {
  // called when .insertIntoDestinationIndexPath
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath,
          let item = coordinator.session.items.first,
          let (sourceIndexPath, sourceTask) = item.localObject as? (IndexPath, Task) else { return }

    viewModel.category.removeFromTasks(sourceTask)

    switch coordinator.proposal.intent {
    case .insertAtDestinationIndexPath:
      viewModel.category.insertIntoTasks(sourceTask, at: destinationIndexPath.row) // reorder

    case .insertIntoDestinationIndexPath:
      var rowIndex = destinationIndexPath.row
      if sourceIndexPath >= destinationIndexPath { rowIndex += 1 }
      viewModel.category.insertIntoTasks(sourceTask, at: rowIndex)
      viewModel.tasks[rowIndex - 1].addToSubtasks(sourceTask)

    default:
      break
    }

    tableView.reloadData()

    viewModel.save()
    item.localObject = nil
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                 withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
		
    guard let (_, sourceTask) = session.items.first?.localObject as? (IndexPath, Task),
          let destinationIndexPath = destinationIndexPath
    else { return UITableViewDropProposal(operation: .cancel, intent: .unspecified) }

    guard destinationIndexPath.row < viewModel.category.tasks.count else {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    print(viewModel.tasks[destinationIndexPath.row].title, destinationIndexPath.row)
    guard let detinationTask = viewModel.category.tasks[destinationIndexPath.row] as? Task else {
      return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    if sourceTask.isParent || sourceTask == detinationTask || detinationTask.isSubtask {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    return UITableViewDropProposal(operation: .move, intent: .automatic)
  }
}

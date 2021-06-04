//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Drag - Drop. move cells
extension RemindersViewController: UITableViewDragDelegate {
  func tableView( _ tableView: UITableView, itemsForBeginning
                    session: UIDragSession, at indexPath: IndexPath ) -> [UIDragItem] {
    session.localContext = viewModel.tasks[indexPath.row]
    return [UIDragItem(itemProvider: NSItemProvider())]
  }
}

extension RemindersViewController: UITableViewDropDelegate {
  // called when .insertIntoDestinationIndexPath
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let parentIndexPath = coordinator.destinationIndexPath,
					let sourceIndexPath = coordinator.session.localDragSession?.localContext as? IndexPath else { return }
    
		if coordinator.proposal.intent == .insertIntoDestinationIndexPath {
      viewModel.setSubtasks(parent: parentIndexPath, child: sourceIndexPath)
    }
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                 withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
		
    guard let sourceTask = session.localDragSession?.localContext as? Task,
          let destinationIndexPath = destinationIndexPath
    else { return UITableViewDropProposal(operation: .cancel, intent: .unspecified) }

    var capturedList = viewModel.tasks
    capturedList.removeAll { $0.objectID == sourceTask.objectID }

    guard destinationIndexPath.row < capturedList.count else {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    let detinationTask = capturedList[destinationIndexPath.row]
    if sourceTask.isParent || sourceTask == detinationTask || detinationTask.isSubtask {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    return UITableViewDropProposal(operation: .move, intent: .automatic)
  }
}

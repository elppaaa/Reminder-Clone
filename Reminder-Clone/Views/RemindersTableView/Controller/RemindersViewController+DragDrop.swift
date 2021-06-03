//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Drag - Drop. move cells
extension RemindersViewController: UITableViewDragDelegate {
  func tableView( _ tableView: UITableView, itemsForBeginning
                    session: UIDragSession, at indexPath: IndexPath ) -> [UIDragItem] {
		session.localContext = indexPath
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
		
		var proposal = UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    guard let sourceIndexPath = session.localDragSession?.localContext as? IndexPath else { return proposal }
		if sourceIndexPath == destinationIndexPath { return proposal } // cancel when same IndexPath

    // if task has subtask, .insertAtDestinationIndexPath only
    if let count = viewModel.tasks[sourceIndexPath.row].subtasks?.count, count > 0 {
			proposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    } else {
			 proposal = UITableViewDropProposal(operation: .move, intent: .automatic)
		 }
	
		return proposal
  }
}

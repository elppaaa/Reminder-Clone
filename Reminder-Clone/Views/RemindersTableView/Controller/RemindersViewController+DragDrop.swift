//
// Created by JK on 2021/06/01.
//

import UIKit

// MARK: - Drag - Drop. move cells
extension RemindersViewController: UITableViewDragDelegate {
  func tableView( _ tableView: UITableView, itemsForBeginning
                    session: UIDragSession, at indexPath: IndexPath ) -> [UIDragItem] {

    [UIDragItem(itemProvider: NSItemProvider())]
  }
}

extension RemindersViewController: UITableViewDropDelegate {
  // called when .insertIntoDestinationIndexPath
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let parentIndexPath = coordinator.destinationIndexPath,
          coordinator.proposal.intent == .insertIntoDestinationIndexPath,
          coordinator.proposal.operation == .move,
          let indexPath = coordinator.items.first?.sourceIndexPath else { return }

    viewModel.setSubtasks(parent: parentIndexPath, child: indexPath)
  }

  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                 withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    
    if session.localDragSession == nil {
      return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    return UITableViewDropProposal(operation: .move, intent: .automatic)
  }
}

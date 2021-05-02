//
// Created by JK on 2021/05/02.
//

import UIKit

class DetailReminderSubtasksViewController: UITableViewController {
  var data = ["AAA", "BBB", "CCC"]
  
  override func loadView() {
    super.loadView()
    tableView.register(DetailReminderSubtaskCell.self, forCellReuseIdentifier: DetailReminderSubtaskCell.identifier)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count + 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
    if indexPath.row == data.count {
      let cell = UITableViewCell()
      cell.imageView?.image = UIImage()
      cell.textLabel?.text = "     Add Reminder"
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailReminderSubtaskCell.identifier)
      as? DetailReminderSubtaskCell else { return UITableViewCell() }
    cell.textLabel?.text = data[indexPath.row]
    cell.imageView?.image = .emptyCircle
    return cell
  }
}

class DetailReminderSubtaskCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  var isDone = false
  
  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    imageView?.image = UIImage()
    
    selectionStyle = .none
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isDoneToggle)))
  }
  
  @objc
  func isDoneToggle() {
    isDone.toggle()
    imageView?.image = isDone ? UIImage.largeCircle : UIImage.emptyCircle
    layoutIfNeeded()
  }
}

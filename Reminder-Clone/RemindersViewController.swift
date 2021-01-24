//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit

// TODO: Get from core data
struct MyTask {
  var id: Int
  var title: String
  var isDone: Bool = false
}

class RemindersViewController: UITableViewController, ViewControllerConfig {
  // TODO: Get from core data
  var pagePrimaryColor: UIColor = .clear
  fileprivate var tasks: [MyTask] = [
    MyTask(id: 0, title: "title"),
    MyTask(id: 1, title: "one"),
    MyTask(id: 2, title: "two"),
  ]
  
  required init?(coder: NSCoder) {
    fatalError("Not Used")
  }
  
  init(primaryColor color: UIColor) {
    super.init(style: .plain)
    self.pagePrimaryColor = color
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackgorund
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.describe)
    
    tableView.estimatedRowHeight = 20

    configLayout()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateArray), name: Notification.sendisDone, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    globalVCConfig()
    navigationController?.navigationBar.prefersLargeTitles = true
    print("📌 color! \(pagePrimaryColor.description)")

    let attribute = [NSAttributedString.Key.foregroundColor:pagePrimaryColor]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func updateArray(_ noti: Notification) {
    guard let data = noti.object as?  MyTask else { return }
    self.tasks = tasks.map { task -> MyTask in
      var task = task
      if task.id == data.id {
        task.isDone.toggle()
      }
      return task
    }
    
    tableView.reloadData()
  }

  #if DEBUG
  @objc func injected() {
    let vc = RemindersViewController(primaryColor: .blue)
    homeInject(vc)
  }
  #endif
}

// MARK: - Layout, Gesture setting
extension RemindersViewController {
  fileprivate func configLayout() {
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
  }
  
}

// MARK: - TableView setting
extension RemindersViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: UILabel -> UITextView로 변경 (CustomUI)
  }
}

// MARK: - TableView DataSource
extension RemindersViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderTableViewCell.describe, for: indexPath) as? ReminderTableViewCell else {
      fatalError("Cell Not Founded")
    }
    let data = tasks[indexPath.row]
    cell.config(color: pagePrimaryColor)
    cell.config(data: data)
    return cell
  }

}

extension RemindersViewController {
  @objc func checkDoneStatus() {
    
  }
}

class ReminderTableViewCell: UITableViewCell {
  var color: UIColor = .clear
  var data: MyTask? = nil {
    didSet {
      guard let data = data else { return }
      self.textLabel?.text = data.title
      if data.isDone {
        self.textLabel?.textColor = .gray
        self.imageView?.tintColor = color
        self.imageView?.image = R.Image.largeCircle
      } else {
        self.textLabel?.textColor = .black
        self.imageView?.tintColor = .gray
        self.imageView?.image = R.Image.emptyCircle
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
    imageView?.contentMode = .scaleAspectFill
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifyIndex)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not used Initializer")
  }
  
  func config(color: UIColor) {
    self.color = color
  }
  
  func config(data: MyTask) {
    self.data = data
  }

  @objc func notifyIndex() {
    NotificationCenter.default.post(name: Notification.sendisDone, object: data)
  }
  
}

fileprivate extension Notification {
  static let sendisDone = NSNotification.Name(rawValue: "SendDone")
}

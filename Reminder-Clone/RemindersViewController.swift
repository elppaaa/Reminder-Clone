//
//  RemindersViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/14.
//

import UIKit

// TODO: Get from core data
struct MyTask {
  var title: String
  var isDone: Bool = false
}

class RemindersViewController: UITableViewController, ViewControllerConfig {
  // TODO: Get from core data
  let pagePrimaryColor: UIColor = .systemPink
  var tasks: [MyTask] = [
    MyTask(title: "title"),
    MyTask(title: "one"),
    MyTask(title: "two"),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = R.Color.defaultBackgorund
    tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.describe)
    
    tableView.estimatedRowHeight = 20

    configLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    globalVCConfig(title: "미리 알림")
    let attribute = [NSAttributedString.Key.foregroundColor:pagePrimaryColor]
    navigationController?.navigationBar.largeTitleTextAttributes = attribute
  }

  #if DEBUG
  @objc func injected() {
    let vc = RemindersViewController()
    homeInject(vc)
  }
  #endif
}

// MARK: - Layout, Gesture setting
extension RemindersViewController {
  func configLayout() {
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
  }
  
}

// MARK: - TableView setting
extension RemindersViewController {
  // TODO: imageView - toggle 로 변경 예정.
  /*
   toggle 시 2-3 초 뒤에 숨기기 적용되도록 함.
   show complete 을 통해서 완료된 항목도 볼 수 있어야 함으로 삭제하지 않음.
   */
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tasks[indexPath.row].isDone.toggle()
    tableView.reloadRows(at: [indexPath], with: .automatic)
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
    cell.configCell(with: data)
    return cell
  }

}

class ReminderTableViewCell: UITableViewCell {
  var data: MyTask = MyTask(title: "") {
    didSet {
      self.textLabel?.text = data.title
      if data.isDone {
        self.textLabel?.textColor = .gray
        self.imageView?.image = R.Image.largeCircle
        self.imageView?.tintColor = .systemPink
      } else {
        self.textLabel?.textColor = .black
        self.imageView?.image = R.Image.emptyCircle
        self.imageView?.tintColor = .gray
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: Self.describe)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not used Initializer")
  }

  func configCell(with data: MyTask) {
    self.data = data
    
  }

}

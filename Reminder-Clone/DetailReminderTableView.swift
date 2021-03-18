//
//  DetailReminderTableView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/03/15.
//

import UIKit

enum DetailReminderTaskKey {
  case title, memo, URL, date, location,
       flag, priority, list, subtasks, image
  
}

protocol DetailReminderTableViewDelegate: UITableView { }

class DetailReminderTableView: UITableView {
  let data: [DetailReminderTaskKey: Any] = [:]
  
  override init(frame: CGRect, style: UITableView.Style) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: .grouped)
    }
    
    register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.describe)
    register(DetailReminderDateCell.self, forCellReuseIdentifier: DetailReminderDateCell.describe)
    
    dataSource = self
    delegate = self
    
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    rowHeight = Self.automaticDimension
    estimatedRowHeight = 44
  }

  class DetailReminderDateView: UIView {
    required init?(coder: NSCoder) {
      fatalError("Do not use this initializer")
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
  }
}
// MARK: - DetailReminderTableViewDelegate // ViewModel 분리 예정

extension DetailReminderTableView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: will change
    switch section {
    case 0:
      return 3
    case 1:
      return 2
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // TODO: will change
    /// row height 별로 switch - case 만들기 vs 2차원 배열사용
    switch indexPath.section {
    case 0:
      let cell = DetailReminderInputCell()
      cell.delegate = self
      return cell
    case 1:
      switch indexPath.row {
      case 0:
        return DetailReminderDateCell(isTimePicker: false)
      case 1:
        return DetailReminderDateCell(isTimePicker: true)
      default:
        return UITableViewCell()
      }
    default:
      return UITableViewCell()
    }
  }
  
}

extension DetailReminderTableView: UITableViewDelegate { }

extension DetailReminderTableView: DetailReminderTableViewDelegate { }

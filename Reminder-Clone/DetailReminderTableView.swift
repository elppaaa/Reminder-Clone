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


class DetailReminderTableView: UITableView {
  let data: [DetailReminderTaskKey: Any] = [:]
  var viewModel = DetailReminderViewModel()
  
  override init(frame: CGRect, style: UITableView.Style) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: .grouped)
    }
    
    register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.describe)
    register(DetailReminderDateCell.self, forCellReuseIdentifier: DetailReminderDateCell.describe)
    
    dataSource = viewModel
    delegate = viewModel
    viewModel._tableView = self
    
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



//
//  DetailReminderTableView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/03/15.
//

import UIKit

class DetailReminderTableView: UITableView {
  /*
   ViewModel 에 data 를 fetch 하여
   data dictionary 에 할당해 줄 함수가 필요함.
   CoreData - Task Entity 가져오기.
   Entity 에서 가져온 값을 이용해 Dictionary 로 parse 작업 수행
   그런데, 이게 Data 에 있어야 하나? View Model 이 이니고? tableView 는 tableView 에.
   CoreData 처리는 따로 클래스를 생성. ViewModel 에서는 필요한 데이터를 가져오는 명령 / 및 결과만 가져오기.
   
   */
  let data: [TaskAttributesKey: Any] = [:]
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .insetGrouped)
    
    register(DetailReminderInputCell.self, forCellReuseIdentifier: DetailReminderInputCell.identifier)
    register(DetailReminderDateCell.self, forCellReuseIdentifier: DetailReminderDateCell.identifier)
    register(DetailReminderToggleCell.self, forCellReuseIdentifier: DetailReminderToggleCell.identifier)
    
    allowsMultipleSelectionDuringEditing = true
    
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    rowHeight = Self.automaticDimension
    estimatedRowHeight = 50
    keyboardDismissMode = .interactive
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

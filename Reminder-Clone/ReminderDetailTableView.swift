//
//  ReminderDetailTableView.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/23.
//

import UIKit

class ReminderDetailTableView: UITableView {
  let bindDataSource = ReminderDetailTableViewDataSource()

  required init?(coder: NSCoder) {
    fatalError("ERROR WHEN CREATE TABLEVIEW")
  }
  
  override init(frame: CGRect, style: UITableView.Style = .grouped) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: style)
    }
    register(InputTextField.self, forCellReuseIdentifier: InputTextField.identifier)
    register(SelectTypeCell.self, forCellReuseIdentifier: SelectTypeCell.identifier)
    translatesAutoresizingMaskIntoConstraints = false
    dataSource = bindDataSource
    delegate = bindDataSource
    backgroundColor = .clear
    configLayout()
  }

  func configLayout() {
    tableHeaderView = UIView()
    tableFooterView = UIView()
    backgroundColor = .none
  }

  #if DEBUG
  @objc func injected() {
    let vc = ReminderDetailViewController()
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = nil
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = UINavigationController(rootViewController: vc)
  }
  #endif
}

struct Icon {
  let image: UIImage
  let color: UIColor
  init(_ image: UIImage, _ color: UIColor) {
    self.image = image
    self.color = color
  }
}

class ReminderDetailTableViewDataSource: NSObject {
  struct DataType {
    let icon: Icon?
    let title: String
    let isOn: Bool?
    init(title: String) {
      self.title = title
      self.icon = nil
      self.isOn = nil
    }
    init(title: String, icon: Icon) {
      self.title = title
      self.icon = icon
      self.isOn = false
    }
  }
  
  fileprivate let cellDictionary: [[DataType]] = [
    [
      DataType(title: "Title"),
      DataType(title: "Notes"),
      DataType(title: "URL"),
    ],
    [
      DataType(title: "Date", icon: Icon(.calendar, .systemRed))
    ]
  ]

  override init() {
    super.init()
  }
}

extension ReminderDetailTableViewDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    cellDictionary.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cellDictionary[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = cellDictionary[indexPath.section][indexPath.row]
    
    if data.icon == nil {
      if let cell = tableView.dequeueReusableCell(withIdentifier: InputTextField.identifier, for: indexPath)
      as? InputTextField {
        cell.config(placeholder: data.title)
        return cell
      }
    } else {
      if let cell = tableView.dequeueReusableCell(withIdentifier: SelectTypeCell.identifier, for: indexPath)
          as? SelectTypeCell {
        cell.config(data: data)
        return cell
      }
    }
    return UITableViewCell()
  }
  
}

extension ReminderDetailTableViewDataSource: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    CGFloat(44)
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    UIView()
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    CGFloat(30)
  }
}

class ReminderDetailTableViewCell: UITableViewCell {
  let textField: UITextField = {
    let t = UITextField()
    t.translatesAutoresizingMaskIntoConstraints = false
    return t
  }()
  
  required init?(coder: NSCoder) {
    fatalError("DO NOT USE THIS INITIALIZER")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
  }
}

class SelectTypeCell: UITableViewCell {
//  fileprivate let icon: UIImageView = {
//    let i = UIImageView()
//    i.translatesAutoresizingMaskIntoConstraints = false
//    i.layer.cornerRadius = 10
//    i.tintColor = .white
//    return i
//  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: Self.identifier)
    configLayout()
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("NOT USED CELL")
  }
  
  fileprivate func configLayout() {
    imageView?.tintColor = .white
    imageView?.layer.cornerRadius = 3
    imageView?.translatesAutoresizingMaskIntoConstraints = false
    imageView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
    imageView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
    imageView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    imageView?.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
    imageView?.contentMode = .center
    imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
  }

  func config(data: ReminderDetailTableViewDataSource.DataType) {
    imageView?.image = data.icon?.image
    imageView?.backgroundColor = data.icon?.color
    textLabel?.text = data.title
  }
  
}

// MARK: -
class InputTextField: UITableViewCell {
  var minHeight: CGFloat?
  fileprivate typealias DataType = ReminderDetailTableViewDataSource.DataType
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    textView.isScrollEnabled = false
    textView.delegate = self
    configLayout()
    selectionStyle = .none
  }

  var textString: String {
    get {
      textView.text
    }
    set {
      textView.text = newValue
      textViewDidChange(textView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("NOT USED CELL")
  }
  
  fileprivate let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
    return t
  }()

  fileprivate func configLayout() {
    contentView.addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      textView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
    ])
  }
  
  func config(placeholder: String) {
    if placeholder == "URL" {
      textView.keyboardType = .URL
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      textView.becomeFirstResponder()
    } else {
      textView.resignFirstResponder()
    }
  }
}

extension InputTextField: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let size = textView.bounds.size
      let newSize = textView.sizeThatFits(size)
      if size.height != newSize.height {
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
        if let thisIndexPath = tableView?.indexPath(for: self) {
          tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
        }
      }
    }
}

/// keyboard type
/// URL input.
///

fileprivate extension UITableViewCell {
  var tableView: UITableView? {
    get {
      var table: UIView? = superview
      while !(table is UITableView) && table != nil {
        table = table?.superview
      }
      return table as? UITableView
    }
  }
}

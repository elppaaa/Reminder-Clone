//
//  DetailReminderInputCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/03/18.
//

import UIKit

// MARK: - Create Custom Cell
class DetailReminderInputCell: UITableViewCell {
  var delegate: DetailReminderTableViewDelegate?
  var cellHeightAnchor: NSLayoutConstraint?
  let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
    t.contentInset.left = 8.0
    return t
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.describe)
    textView.delegate = self
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  func commonInit() {
    textView.isScrollEnabled = true
    contentView.addSubview(textView)
    cellHeightAnchor = textView.heightAnchor.constraint(equalToConstant: 38)
    cellHeightAnchor?.isActive = true
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
      textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
    ])
    
    textViewDidChange(textView)
    textView.resignFirstResponder()
  }
  
}

extension DetailReminderInputCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    cellHeightAnchor?.constant = estimatedSize.height
    delegate?.beginUpdates()
    delegate?.endUpdates()
    UIView.setAnimationsEnabled(false)
  }
}

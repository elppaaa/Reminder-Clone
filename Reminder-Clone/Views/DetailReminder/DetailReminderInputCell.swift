//
//  DetailReminderInputCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/03/18.
//

import UIKit

// MARK: - Create Custom Cell
class DetailReminderInputCell: DetailReminderViewCellBase {
  private var cellHeightAnchor: NSLayoutConstraint?
  var textViewPlaceholder: String = ""
  let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
    t.backgroundColor = .none
    return t
  }()
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  init(placeHolder: String, type: TaskAttributesKey) {
    super.init(style: .default, reuseIdentifier: Self.identifier)
    textViewPlaceholder = placeHolder
    textView.delegate = self
    dataType = type
    commonInit()
  }
  
  func commonInit() {
    selectionStyle = .none
    
    cellHeightAnchor = textView.heightAnchor.constraint(
      equalToConstant: UIFont.preferredFont(forTextStyle: .body).lineHeight)
      .priority(.defaultLow)
    cellHeightAnchor?.isActive = true
    textView.text = textViewPlaceholder
    textView.textColor = .lightGray
    textView.isScrollEnabled = true
    contentView.addSubview(textView)
    textViewDidChange(textView)
    
    let maxHeight = textView.heightAnchor.constraint(lessThanOrEqualToConstant: 120)
    maxHeight.priority = .defaultHigh
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
      textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
      textView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
      textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
      maxHeight
    ])
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.updateConstraintsIfNeeded()
  }
}

extension DetailReminderInputCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    cellHeightAnchor?.constant = estimatedSize.height
    delegate?.updateLayout(nil)
    UIView.setAnimationsEnabled(true)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = .label
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = textViewPlaceholder
      textView.textColor = UIColor.lightGray
    }
  }
}

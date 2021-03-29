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
  private var textViewPlaceholder: String = ""
  private let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
    t.contentInset.left = 8.0
    return t
  }()
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }
  
  init(placeHolder: String) {
    super.init(style: .default, reuseIdentifier: Self.identifier)
    textViewPlaceholder = placeHolder
    textView.delegate = self
    commonInit()
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
    textView.text = textViewPlaceholder
    textView.textColor = .lightGray
    textView.resignFirstResponder()
  }
  
}

extension DetailReminderInputCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    cellHeightAnchor?.constant = estimatedSize.height
    delegate?.tableView?.beginUpdates()
    delegate?.tableView?.endUpdates()
    UIView.setAnimationsEnabled(false)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = textViewPlaceholder
      textView.textColor = UIColor.lightGray
    }
  }
}

//
// Created by JK on 2021/05/04.
//

import UIKit

protocol DetailReminderSubtaskCellDelegate: UITableViewController  {
  func updateCell()
}

class DetailReminderSubtaskCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  var isDone = false
  let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
    t.contentInset.left = 8.0
    t.isScrollEnabled = false
    return t
  }()
  private var textViewHeight: NSLayoutConstraint?
  var delegate: DetailReminderSubtaskCellDelegate?
  
  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    textView.delegate = self
    
    textViewHeight = textView.heightAnchor.constraint(
      equalToConstant: UIFont.preferredFont(forTextStyle: .body).lineHeight)
    textViewHeight?.priority = .defaultLow
    textViewHeight?.isActive = true
    textViewDidChange(textView)
    
    selectionStyle = .none
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isDoneToggle)))
    
    contentView.addSubview(textView)
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
      textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
      textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
    ])
    if let imageView = imageView {
      textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
    }
    
  }
  
  @objc
  func isDoneToggle() {
    isDone.toggle()
    imageView?.image = isDone ? UIImage.largeCircle : UIImage.emptyCircle
    layoutIfNeeded()
  }
}

extension DetailReminderSubtaskCell: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textViewHeight?.constant = estimatedSize.height
    delegate?.updateCell()
    UIView.setAnimationsEnabled(true)
  }
}

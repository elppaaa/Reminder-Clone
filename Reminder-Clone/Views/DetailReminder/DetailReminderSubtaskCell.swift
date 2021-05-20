//
// Created by JK on 2021/05/04.
//

import UIKit

protocol DetailReminderSubtaskCellDelegate: UITableViewController {
  func updateCell()
}

class DetailReminderSubtaskCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  
  var isDone = false
  let textView: UITextView = {
    let t = UITextView()
    t.translatesAutoresizingMaskIntoConstraints = false
    t.font = .preferredFont(forTextStyle: .body)
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
      .priority(.defaultLow)
    textViewHeight?.isActive = true
    textViewDidChange(textView)
    
    selectionStyle = .none
    
    imageView?.isUserInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isDoneToggle)))
    let imageConfig = UIImage.SymbolConfiguration(pointSize: frame.height * 0.5, weight: .light, scale: .medium)
    imageView?.image = R.Image.emptyCircle.image.withConfiguration(imageConfig)
    
    let imageViewTop = imageView?.topAnchor.constraint(equalTo: contentView.topAnchor)
    imageViewTop?.priority = .defaultHigh
    
    contentView.addSubview(textView)
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
      textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
      textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
    ])
    if let imageView = imageView {
      textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
    }
  }
  
  @objc
  func isDoneToggle() {
    isDone.toggle()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .light, scale: .medium)
    imageView?.image = isDone ?
      R.Image.largeCircle.image.withConfiguration(imageConfig) :
      R.Image.emptyCircle.image.withConfiguration(imageConfig)
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

//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit
import Combine

class ReminderTableViewCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    configAction()
    configLayout()
  }
  var layoutUpdate: (() -> Void)?
  fileprivate let inset: CGFloat = 8
  var textViewHeight: NSLayoutConstraint?

  var color: UIColor = .clear
  lazy var iconSize = contentView.bounds.height * 0.6

  @Published var isDone = false {
    didSet {
      if isDone {
        textView.textColor = .gray
        toggleButton.tintColor = color
        toggleButton.image = R.Image.largeCircle.image
      } else {
        textView.textColor = .label
        toggleButton.tintColor = .gray
        toggleButton.image = R.Image.emptyCircle.image
      }
    }
  }

  lazy var toggleButton: UIImageView = {
    $0.bounds.size = CGSize(width: iconSize, height: iconSize)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.preferredSymbolConfiguration = .init(pointSize: iconSize)
    $0.isUserInteractionEnabled = true
    $0.contentMode = .center

    contentView.addSubview($0)
    return $0
  }(UIImageView())

  lazy var textView: UITextView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = true
    $0.delegate = self
    $0.font = .preferredFont(forTextStyle: .body)
    $0.isScrollEnabled = false

    contentView.addSubview($0)
    return $0
  }(UITextView())

  fileprivate func configLayout() {
    selectionStyle = .none
    textViewHeight = textView.heightAnchor.constraint(equalToConstant: contentView.bounds.height)

    textViewHeight?.priority = .defaultLow
    textViewHeight?.isActive = true
    textViewDidChange(textView)

    NSLayoutConstraint.activate([
      toggleButton.topAnchor.constraint(
        equalTo: contentView.safeAreaLayoutGuide.topAnchor,
        constant: (contentView.bounds.height - toggleButton.bounds.height) * 0.5),
      toggleButton.safeAreaLayoutGuide.leadingAnchor.constraint( equalTo: contentView.leadingAnchor, constant: inset),
      toggleButton.heightAnchor.constraint(equalToConstant: iconSize),
      toggleButton.widthAnchor.constraint(equalToConstant: iconSize),

      textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: inset * 0.5),
      textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: inset * -0.5),
      textView.leadingAnchor.constraint(equalTo: toggleButton.trailingAnchor, constant: inset),
      textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: inset * -1)
    ])

    separatorInset.left = inset * 2 + toggleButton.bounds.width
  }

  fileprivate func configAction() {
    toggleButton.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(toggleIsDone)))
  }

  @objc func toggleIsDone() {
    isDone.toggle()
  }
}

extension ReminderTableViewCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    accessoryType = .detailButton
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    accessoryType = .none
  }

  func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textViewHeight?.constant = estimatedSize.height
    layoutUpdate?()
    UIView.setAnimationsEnabled(true)
  }
}

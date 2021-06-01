//
//  RemindersTableViewCell.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/20.
//

import UIKit
import Combine
import CoreData.NSManagedObjectID

class ReminderTableViewCell: UITableViewCell {
  required init?(coder: NSCoder) { fatalError("Do not use this initializer") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: Self.identifier)
    configAction()
    configLayout()
  }
	
  var cancel = Set<AnyCancellable>()
  var delegate: ReminderTableViewCellDelegate?
  var id: NSManagedObjectID?
  override var indentationLevel: Int {
    get { _indentationLevel }
    set { _indentationLevel = newValue }
  }
  fileprivate var _indentationLevel = 0  {
    didSet {
			let insetWidth = inset * 2 + toggleButton.bounds.width
			separatorInset.left = _indentationLevel == 0 ?
        insetWidth : insetWidth * 2.0
      indentation.constant = _indentationLevel == 0 ?
        inset : insetWidth * 1.0
    }
  }
  fileprivate let inset: CGFloat = 8
  fileprivate lazy var textViewHeight: NSLayoutConstraint =
    textView.heightAnchor.constraint(equalToConstant: textView.contentSize.height) .priority(.defaultLow)
  fileprivate lazy var indentation: NSLayoutConstraint =
    stack.leadingAnchor.constraint(
      equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: inset)
  var flagVisible = false {
    didSet { flag.isHidden = !flagVisible }
  }

  var color: UIColor = .clear {
    didSet {
      flag.tintColor = color
      priorityView.textColor = color
    }
  }

  var priority: Int16 = 0 {
    didSet {
      if priority == 0 {
        priorityView.isHidden = true
      } else {
        priorityView.isHidden = false
        priorityView.text = String(repeating: "!", count: Int(priority)) + " "
      }
    }
  }

  fileprivate lazy var iconSize = contentView.bounds.height * 0.6

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

  fileprivate lazy var stack: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .horizontal
    $0.alignment = .firstBaseline
    $0.distribution = .fillProportionally
    $0.spacing = inset

    return $0
  }(UIStackView())

  lazy var toggleButton: UIImageView = {
    $0.bounds.size = CGSize(width: iconSize, height: iconSize)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.preferredSymbolConfiguration = .init(pointSize: iconSize)
    $0.isUserInteractionEnabled = true
    $0.contentMode = .center
    $0.tintColor = color

    return $0
  }(UIImageView())

  private lazy var priorityView = UILabel.makeView(color: color, font: .preferredFont(forTextStyle: .body))

  lazy var textView: UITextView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = false
    $0.backgroundColor = .none
    $0.delegate = self
    $0.font = .preferredFont(forTextStyle: .body)
    $0.isScrollEnabled = false
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 0

    return $0
  }(UITextView())

  fileprivate lazy var flag: UIImageView = {
    $0.bounds.size = CGSize(width: iconSize, height: iconSize)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.preferredSymbolConfiguration = .init(pointSize: iconSize)
    $0.isUserInteractionEnabled = true
    $0.contentMode = .center
    $0.image = R.Image.flag.image

    return $0
  }(UIImageView())

  fileprivate func configLayout() {
    priorityView.lineBreakMode = .byWordWrapping

		contentView.addSubview(stack)

    stack.addArrangedSubview(toggleButton)
    stack.addArrangedSubview(priorityView)
    stack.addArrangedSubview(textView)
    stack.addArrangedSubview(flag)

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: inset),
      stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -1 * inset),
      indentation,
      stack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -1 * inset),
  
      textViewHeight,
			
      toggleButton.heightAnchor.constraint(equalToConstant: iconSize),
      toggleButton.widthAnchor.constraint(equalToConstant: iconSize),

      flag.widthAnchor.constraint(equalToConstant: iconSize),
      flag.heightAnchor.constraint(equalToConstant: iconSize),
    ])

    textViewDidChange(textView)
		
    separatorInset.left = inset * 2 + toggleButton.bounds.width
    indentationWidth = separatorInset.left
  }

  fileprivate func configAction() {
    toggleButton.publisher(.tap)
      .sink { [weak self] _ in self?.isDone.toggle() }
      .store(in: &cancel)
  }
}

extension ReminderTableViewCell: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    accessoryType = .none
    if textView.text == "", let id = id {
      delegate?.removeCell(id: id)
    }
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    accessoryType = .detailButton
  }

  func textViewDidChange(_ textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    let size = CGSize(width: contentView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textViewHeight.constant = estimatedSize.height
    delegate?.updateCellLayout(nil)
    UIView.setAnimationsEnabled(true)
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n", let id = id {
      delegate?.insertTask(id: id, animate: .fade)
      return false
    }

    return true
  }
}

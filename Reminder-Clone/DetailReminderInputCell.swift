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
		t.sizeToFit()
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
		cellHeightAnchor = textView.heightAnchor.constraint(equalToConstant: 0)
		cellHeightAnchor?.priority = .defaultLow
		cellHeightAnchor?.isActive = true
		textView.text = textViewPlaceholder
		textView.textColor = .lightGray
		textView.isScrollEnabled = true
		textViewDidChange(textView)
		contentView.addSubview(textView)

		let maxHeight = textView.heightAnchor.constraint(lessThanOrEqualToConstant: textView.font!.lineHeight * 4)
		maxHeight.priority = .defaultHigh

		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: contentView.topAnchor),
			textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
		delegate?.tableView?.beginUpdates()
		delegate?.tableView?.endUpdates()
		UIView.setAnimationsEnabled(true)
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		guard let valueType = dataType else { return }

		if textView.text.isEmpty {
			textView.text = textViewPlaceholder
			textView.textColor = UIColor.lightGray
			delegate?.setValue(key: valueType, value: "")
		} else {
			if let text = textView.text {
				delegate?.setValue(key: valueType, value: text)
			}
		}
	}
}

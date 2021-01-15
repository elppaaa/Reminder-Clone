//
// Created by JK on 2021/01/09.
//

import UIKit

class HomeRadiusListCell: UICollectionViewCell, HomeListCellViewType {
	static let size: CGFloat = 35.0

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		configLayout()
	}

	required init?(coder: NSCoder) {
    super.init(coder: coder)
    configLayout()
  }
  
	private let mainStack: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .fill
		stack.distribution = .equalCentering
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
		return stack
	}()

	private let stack: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .horizontal
		stack.alignment = .fill
		stack.distribution = .equalCentering
		return stack
	}()

	var iconView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
//		imageView.image = UIImage()
		imageView.backgroundColor = .white
		imageView.layer.cornerRadius = size / 2
		imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
		imageView.contentMode = .scaleToFill
		return imageView
	}()

	var countLabel: UILabel = {
		let label = UILabel.makeView(
			font: .systemFont(ofSize: (size * 0.8), weight: .bold))

		return label
	}()

	var titleLabel: UILabel = {
		let label = UILabel.makeView(color: .gray, font:
		.systemFont(ofSize: (size * 0.5), weight: .semibold))

		return label
	}()

  // MARK: - configureLayout
	func configLayout() {
		backgroundColor = R.color.systemBackground
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		layer.cornerRadius = 10
		frame.size.height = 100
		frame.size.width = 180

		stack.addArrangedSubview(iconView)
		stack.addArrangedSubview(countLabel)

		mainStack.addArrangedSubview(stack)
		mainStack.addArrangedSubview(titleLabel)
		addSubview(mainStack)

		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: topAnchor),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
		widthAnchor.constraint(greaterThanOrEqualToConstant: 165).isActive = true
	}

  @objc func injected() {
    inject()
  }
}

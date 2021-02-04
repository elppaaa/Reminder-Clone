//
// Created by JK on 2021/01/10.
//

import UIKit

// TODO: - UITableView 완성할 것.
/*
 UITableView 에서, collapse 고려하여
 stackview, collectionview, tableview 중에서
 어떤 뷰로 표시할 것인지를 고민 후 재 작성 예정.
 */

// MARK: -
class HomeListTableView: UITableView {
	let bindDataSource = HomeListTableDataSource()
  weak var viewController: UIViewController?
  @objc dynamic var height: CGFloat {
    contentSize.height
  }
  
	required init?(coder: NSCoder) {
		fatalError("ERROR WHEN CREATE TABLEVIEW")
	}
  
	override init(frame: CGRect, style: Style = .grouped) {
    if #available(iOS 13, *) {
      super.init(frame: frame, style: .insetGrouped)
    } else {
      super.init(frame: frame, style: style)
    }
		dataSource = bindDataSource
    delegate = self
		register(HomeListTableCell.self, forCellReuseIdentifier: HomeListTableCell.describe)
		configLayout()
		reloadData()
	}
  
  convenience init() {
    self.init(frame: .zero)
		dataSource = bindDataSource
    delegate = self
		register(HomeListTableCell.self, forCellReuseIdentifier: HomeListTableCell.describe)
    configLayout()
	}
  
  func configLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .none
    rowHeight = CGFloat(50)
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    isScrollEnabled = false
    tableFooterView = UIView()
  }
  
  #if DEBUG
  @objc func injected() {
    inject()
  }
  #endif
  
  func inject() {
    //change vc
    let vc = ViewController()
    let navigation = UINavigationController(rootViewController: vc)
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = nil
    //swiftlint:disable force_unwrapping
    UIApplication.shared.windows.first!.rootViewController = navigation
  }

}

extension HomeListTableView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = viewController {
      let data = bindDataSource.data[indexPath.row]
      let reminderVC = RemindersTableViewController()
			reminderVC.pagePrimaryColor = data.color
      reminderVC.title = data.title
      vc.navigationController?.pushViewController(reminderVC, animated: true)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: -
class HomeListTableDataSource: NSObject, HomeListDataSource {
	var data: [HomeRadiusList] {
		_data
	}

	private var _data: [HomeRadiusList] = [
    HomeRadiusList(title: "Today", icon: .folderCircle, color: .systemBlue, count: 5),
    HomeRadiusList(title: "Scheduled", icon: .calenderCircle, color: .red, count: 9),
    HomeRadiusList(title: "All", icon: .trayCircle, color: .gray, count: 8),
    HomeRadiusList(title: "Flagged", icon: .flagCircle, color: .systemOrange, count: 7),
    HomeRadiusList(title: "Flagged", icon: .flagCircle, color: .systemOrange, count: 7),
	]
}

extension HomeListTableDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeListTableCell.describe, for: indexPath)
			as? HomeListTableCell else {
			fatalError("ERROR WHEN CREATE CELL")
		}
		let data = _data[indexPath.row]
    tableView.beginUpdates()
		cell.configCell(with: data)
    tableView.endUpdates()
		return cell
	}
}

// MARK: -
class HomeListTableCell: UITableViewCell, HomeListCellViewType {
  private static let size: CGFloat = 40
	required init?(coder: NSCoder) {
		fatalError("ERROR")
	}

	override init(style: CellStyle, reuseIdentifier _: String? = nil) {
		super.init(style: style, reuseIdentifier: Self.describe)
		configLayout()
	}

	var titleLabel = UILabel.makeView(
		font: .systemFont(ofSize: size / 2))

	var countLabel = UILabel.makeView(
    color: .gray,
    font: .systemFont(ofSize: size / 2))

	var iconView: UIImageView = {
    let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleToFill
    imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
		return imageView
	}()

	fileprivate func configLayout() {
		translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = R.Color.systemBackground

		accessoryType = .disclosureIndicator
    
    contentView.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)
    contentView.subviews.forEach { v in
      v.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 7),
      countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
    ])

	}
}

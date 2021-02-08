//
// Created by JK on 2021/02/07.
//

import UIKit

// DetailTaskPresentData 와 DetailTaskData<T>가 같은 indexPath로 구성되도록 함.

struct DetailTaskPresentData {
  enum CellType {
    case input, toggle, picker
  }
  enum CellPresentData {
    case title, image, color
  }
  
  let type: CellType
  var cellData: [CellPresentData: Any]
}

class DetailTaskData<T>: Box<T> {
  var isPresented: Bool = true
  var isUsed: Bool = true
}

struct DetailTaskCellData<T> {
  let present: DetailTaskPresentData
  var value: DetailTaskData<T>
}

// MARK: -
class DetailTaskTableView: UITableView {
	let viewModel = DetailTaskTableViewModel()
	required init?(coder: NSCoder) {
		fatalError("Not Used")
	}
	override init(frame: CGRect, style: Style) {
		if #available(iOS 13, *){
			super.init(frame: frame, style: .insetGrouped)
		} else {
			super.init(frame: frame, style: .grouped)
		}

		commonInit()
	}

	func commonInit() {
		dataSource = viewModel
	}
}

// MARK: -
/// cells[section][row]
class DetailTaskTableViewModel: NSObject {
  var data: [[DetailTaskCellData<Any>]] = [
    [
      .init(present: DetailTaskPresentData(type: .input, cellData: [.title: "Title"]),
                                 value: DetailTaskData(" ")),
      .init(present: DetailTaskPresentData(type: .input, cellData: [.title: "Memo"]),
                                 value: DetailTaskData(" ")),
      .init(present: DetailTaskPresentData(type: .input, cellData: [.title: "URL"]),
                                 value: DetailTaskData(" ")),
    ]
  ]
}

extension DetailTaskTableViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data[section].filter { $0.value.isPresented == true }.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = cellSelector(tableView, indexPath: indexPath)
		// TODO: - ConfigData
		return cell
	}

	fileprivate func cellSelector(_ tableView: UITableView, indexPath: IndexPath) -> DetailTaskTableViewCellType {
    let cellType = data[indexPath.section][indexPath.row].present.type
		switch cellType {
		case .input:
      if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskInputTableViewCell.describe, for: indexPath) as? DetailTaskTableViewCellType {
				return _cell
			}
		case .toggle:
			if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskToggleTableViewCell.describe, for: indexPath) as? DetailTaskTableViewCellType {
				return _cell
			}
		case .picker:
			if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskInputTableViewCell.describe, for: indexPath) as? DetailTaskTableViewCellType {
				return _cell
			}
		}
		fatalError("[DetailTaskTableViewModel] Cell Type Error: \(cellType)")
	}
}

// MARK: - CellType
protocol DetailTaskTableViewCellType: UITableViewCell {
}

class DetailTaskInputTableViewCell: UITableViewCell, DetailTaskTableViewCellType {

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
  }

}

class DetailTaskToggleTableViewCell: UITableViewCell, DetailTaskTableViewCellType {

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
	}
}

class DetailTaskPickerTableViewCell: UITableViewCell, DetailTaskTableViewCellType {

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
	}
}

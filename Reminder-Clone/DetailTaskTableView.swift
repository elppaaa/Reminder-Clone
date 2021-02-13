//
// Created by JK on 2021/02/07.
//

import UIKit

// DetailTaskPresentData 와 DetailTaskData<T>가 같은 indexPath로 구성되도록 함.

struct DetailTaskPresentData {
  enum CellType {
    case input, toggle, picker
  }
  enum CellPresentKey {
    case title, image, color
  }
  
  let type: CellType
  var cellData: [CellPresentKey: Any]
}

class DetailTaskData<T>: Box<T> {
  var isPresented: Bool
  var isUsed: Bool
//  var observation: NSKeyValueObservation?

	override init(_ value: T) {
    self.isPresented = true
    self.isUsed = true
    super.init(value)
  }
	convenience init(_ value: T, isPresented: Bool = true, isUsed: Bool = true) {
		self.init(value)
		self.isPresented = isPresented
		self.isUsed = isUsed
	}
}

extension DetailTaskData: DetailTaskDataDelegate  {
  func changeValue<DataType>(_ _value: DataType) {
    if let value = _value as? T {
      self.value = value
    }
  }
}

struct DetailTaskCellData<T> {
  let present: DetailTaskPresentData
  var data: DetailTaskData<T>
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
    translatesAutoresizingMaskIntoConstraints = false
    register(DetailTaskInputTableViewCell.self, forCellReuseIdentifier: DetailTaskInputTableViewCell.describe)
    register(DetailTaskToggleTableViewCell.self, forCellReuseIdentifier: DetailTaskToggleTableViewCell.describe)
    register(DetailTaskPickerTableViewCell.self, forCellReuseIdentifier: DetailTaskPickerTableViewCell.describe)
		dataSource = viewModel
	}
}

// MARK: -
/// cells[section][row]
class DetailTaskTableViewModel: NSObject {
  var data: [[DetailTaskCellData<Any>]] = [
    [
      .init(present: .init(type: .input, cellData: [.title: "Title"]),
            data: .init(" ")),
      .init(present: .init(type: .input, cellData: [.title: "Memo"]),
            data: .init(" ")),
      .init(present: .init(type: .input, cellData: [.title: "URL"]),
            data: .init(" ")),
    ],
//    [
//      .init(present: .init(type: .toggle, cellData: [.title: "Date"]),
//            value: .init(false, isUsed: false)),
//      .init(present: .init(type: .picker, cellData: [.title: "date"]),
//            value: .init(Date())),
//      .init(present: .init(type: .toggle, cellData: [.title: "Time"]),
//            value: .init(false, isUsed: false))
//
//    ]
  ]
  
  func task(_ indexPath: IndexPath) -> DetailTaskCellData<Any> {
    data[indexPath.section][indexPath.row]
  }
}

extension DetailTaskTableViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data[section].filter { $0.data.isPresented == true }.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let option = task(indexPath)
		let cell = cellSelector(tableView, indexPath: indexPath)
    cell.delegate = option.data
		return cell
	}

  fileprivate func cellSelector(_ tableView: UITableView, indexPath: IndexPath) -> DetailTaskTableViewCellType {
    let cellType = task(indexPath).present.type
		switch cellType {
		case .input:
      if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskInputTableViewCell.describe, for: indexPath) as? DetailTaskInputTableViewCell {
				return _cell
			}
		case .toggle:
			if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskToggleTableViewCell.describe, for: indexPath) as? DetailTaskToggleTableViewCell {
				return _cell
			}
		case .picker:
			if let _cell = tableView.dequeueReusableCell(withIdentifier: DetailTaskInputTableViewCell.describe, for: indexPath) as? DetailTaskPickerTableViewCell {
				return _cell
			}
		}
		fatalError("[DetailTaskTableViewModel] Cell Type Error: \(cellType)")
	}
}

// MARK: - CellType
protocol DetailTaskTableViewCellType: UITableViewCell {
  var delegate: DetailTaskDataDelegate? { get set }
}

protocol DetailTaskDataDelegate {
  func changeValue<T>(_ value: T)
}

class DetailTaskInputTableViewCell: UITableViewCell, DetailTaskTableViewCellType {
  var delegate: DetailTaskDataDelegate?
  var observation: NSKeyValueObservation?
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
		commonInit()
  }
  
//  let textView: UITextView = {
//    let textView = UITextView()
//    textView.translatesAutoresizingMaskIntoConstraints = false
//    return textView
//  }()
  let textView: UITextField = {
    let t = UITextField()
    t.translatesAutoresizingMaskIntoConstraints = false
    return t
  }()
  
	func commonInit() {
		contentView.addSubview(textView)
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
			textView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
			textView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
		])
    
    textView.addTarget(self, action: #selector(didValueChanged), for: .allEditingEvents)

	}
	@objc func didValueChanged() {
		if let text = textView.text {
			delegate?.changeValue(text)
      print("📌 Delegate Work")
		}
	}
}

class DetailTaskToggleTableViewCell: UITableViewCell, DetailTaskTableViewCellType {
  var delegate: DetailTaskDataDelegate?

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
	}
  
}

class DetailTaskPickerTableViewCell: UITableViewCell, DetailTaskTableViewCellType {
  var delegate: DetailTaskDataDelegate?

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: Self.describe)
	}
}

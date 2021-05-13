//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

class ViewController: UITableViewController {
  fileprivate let controller = UISearchController(searchResultsController: nil)
  fileprivate let viewModel = HomeListTableViewModel()
  fileprivate var observeBag = [NSKeyValueObservation]()
  fileprivate let collection = HomeListCollectionWrappedCell()

  override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.delegate = viewModel
    viewModel.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use this initializer")
  }

  override func viewWillAppear(_ animated: Bool) {
    title = nil
    navigationController?.navigationBar.prefersLargeTitles = false
    configToolbar()
    super.viewWillAppear(true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  override func viewDidLoad() {
    view.backgroundColor = R.Color.applicationBackground
    tableView.dataSource = viewModel
    defaultNavigationConfig()
    searchBarSetting()
    configLayout()
    super.viewDidLoad()
  }
  
  fileprivate func searchBarSetting() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    
    navigationItem.searchController = controller
    navigationItem.searchController?.isActive = true
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  // MARK: - config Layout
  fileprivate func configLayout() {
    tableView.register(HomeListTableCell.self, forCellReuseIdentifier: HomeListTableCell.identifier)
    tableView.rowHeight = CGFloat(50)
    
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.tableHeaderView = collection
  }

  #if DEBUG
  @objc func injected() {
    homeInject()
  }
  #endif
}

extension ViewController: HomeListTableViewModelDelegate {
  func pushVC(_ vc: UIViewController, animated: Bool) {
    navigationController?.pushViewController(vc, animated: animated)
  }
}

extension ViewController {
  fileprivate func configToolbar() {
    navigationController?.isToolbarHidden = false
    navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)

    navigationController?.toolbar.isTranslucent = true

    var arr = [UIBarButtonItem]()

    let label = UILabel.makeView()
    label.attributedText = {
      let attributedString = NSMutableAttributedString(string: "")
      let font = UIFont.preferredFont(forTextStyle: .headline).withSize(18)

      let imageAttach: NSTextAttachment = {
        let attach = NSTextAttachment()
        let image = R.Image.plusCircle.image.with(color: .systemBlue)

        attach.image = image
        attach.bounds = CGRect(x: 0, y: (font.capHeight - 25).rounded() / 2,
                               width: 25, height: 25)
        return attach
      }()

      attributedString.append(NSAttributedString(attachment: imageAttach))
      attributedString.append(NSAttributedString(string: "  New Reminder", attributes: [.foregroundColor: UIColor.systemBlue, .font: font]))

      return attributedString
    }()
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newReminderButtondidTapped)))

    arr.append(UIBarButtonItem(customView: label))
    arr.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
    arr.append(UIBarButtonItem(title: "Add List", style: .plain, target: self, action: #selector(addListButtondidTapped)))

    toolbarItems = arr

  }

  @objc
  func newReminderButtondidTapped() {
    let vc = UINavigationController(rootViewController: NewReminderViewController())
    navigationController?.present(vc, animated: true, completion: nil)
  }

  @objc
  func addListButtondidTapped() {
    let vc = UINavigationController(rootViewController: NewListViewController())
    navigationController?.present(vc, animated: true)
  }

}

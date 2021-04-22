//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

class ViewController: UITableViewController {
  fileprivate let controller = UISearchController(searchResultsController: nil)
//  fileprivate let collection = HomeListCollectionView()
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
    super.viewDidLoad()
    searchBarSetting()
    configLayout()
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
    tableView.estimatedRowHeight = CGFloat(50)
    tableView.rowHeight = UITableView.automaticDimension
    
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

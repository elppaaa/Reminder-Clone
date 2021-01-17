//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

protocol NavigationControllerDelegate { }

class ViewController: UIViewController, ViewControllerConfig {
  let controller = UISearchController(searchResultsController: nil)
  let collection = HomeListCollectionView()
  let table = HomeListTableView()
  var searchBar = UISearchBar()

  fileprivate let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillEqually
    return stack
  }()
  
  fileprivate let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    return scrollView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    globalVCConfig()
    title = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    table.viewController = self
    view.backgroundColor = R.Color.applicationBackground
    searchBarSetting()
    configLayout()
  }

  func searchBarSetting() {
    searchBar = controller.searchBar
//    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.backgroundColor = .clear
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    
    navigationItem.searchController = controller
    navigationItem.searchController?.isActive = true
    navigationItem.hidesSearchBarWhenScrolling = true
  }

  // MARK: - config Layout
  func configLayout() {
    /// add to stack
    // TODO: - UIScrollView 코드로 작성하는 방법 찾기.
    		mainStack.addArrangedSubview(collection)
        mainStack.addArrangedSubview(table)
    
    view.addSubview(mainStack)
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
      mainStack.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -10),
      mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    
    // ListView
  }
  
//  private let stack: UIStackView = {
//    let stack = UIStackView()
//		stack.translatesAutoresizingMaskIntoConstraints = false
//    return stack
//  }()

  #if DEBUG
  @objc func injected() {
    homeInject()
  }
  #endif
}

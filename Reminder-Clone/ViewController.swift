//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

class ViewController: UIViewController {
  
  let controller = UISearchController(searchResultsController: nil)
  let collection = HomeListCollectionView()
	let table = HomeListTableView()
  var searchBar = UISearchBar()

  let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillEqually
    return stack
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = R.color.applicationBackground

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
    // collectionView
		mainStack.addArrangedSubview(collection)
    mainStack.addArrangedSubview(table)

    view.addSubview(mainStack)
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
      mainStack.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -10),
      mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    
//    searchBar.leadingAnchor.constraint(equalTo: UINavigationBar.appearance().leadingAnchor).isActive = true
//    searchBar.trailingAnchor.constraint(equalTo: UINavigationBar.appearance().trailingAnchor).isActive = true

    // ListView
    
  }
  private let stack: UIStackView = {
    let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  #if DEBUG
  @objc func injected() {
    inject()
  }
  #endif
}

//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

class ViewController: UIViewController {
  
  let controller = UISearchController(searchResultsController: nil)
  let collection = HomeRadiusListCollectionView()
  var searchBar = UISearchBar()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = R.color.applicationBackground

    searchBarSetting()
    configLayout()
  }
  
  func searchBarSetting() {
    searchBar = controller.searchBar
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.backgroundColor = .clear
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    
    navigationItem.searchController = controller
    navigationItem.searchController?.isActive = true
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  // MARK: - config Layout
  func configLayout() {
    
    // collectionView
    view.addSubview(collection)
    NSLayoutConstraint.activate([
      collection.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
      collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collection.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      collection.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    
    // ListView
    
  }
  #if DEBUG
  @objc func injected() {
    inject()
  }
  #endif
}

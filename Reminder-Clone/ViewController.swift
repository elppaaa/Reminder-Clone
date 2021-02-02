//
//  ViewController.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit

class ViewController: UIViewController {
  
  fileprivate let controller = UISearchController(searchResultsController: nil)
  fileprivate let collection = HomeListCollectionView()
  fileprivate let table = HomeListTableView()
  fileprivate var searchBar = UISearchBar()
  fileprivate var observeBag = [NSKeyValueObservation]()

  fileprivate var collectionViewHeight: NSLayoutConstraint?
  fileprivate var tableViewHeight: NSLayoutConstraint?
  fileprivate var contentViewHeight: NSLayoutConstraint?
  
  fileprivate let scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: .zero)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isScrollEnabled = true
    scrollView.alwaysBounceVertical = true
    scrollView.isPagingEnabled = true
    return scrollView
  }()
  
  fileprivate let contentView: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    defaultNavigationConfig()
    navigationController?.navigationBar.prefersLargeTitles = false
    title = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    table.viewController = self
    view.backgroundColor = R.Color.applicationBackground
    searchBarSetting()
    configLayout()
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.contentSize = contentView.frame.size
  }

  func searchBarSetting() {
    searchBar = controller.searchBar
    searchBar.backgroundColor = .clear
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    
    navigationItem.searchController = controller
    navigationItem.searchController?.isActive = true
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  // MARK: - config Layout
  func configLayout() {
    // TODO: 스크롤 뷰 내 스크롤 안되는 현상 수정
    
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    
    scrollView.addSubview(contentView)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
      contentView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    ])

    contentView.addSubview(collection)
    contentView.addSubview(table)
    
    NSLayoutConstraint.activate([
      collection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
    
    table.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 10).isActive = true
    if #available(iOS 13, *) {
      NSLayoutConstraint.activate([
        table.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -20),
        table.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
      ])
    } else {
      NSLayoutConstraint.activate([
        table.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        table.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ])
    }

    tableViewHeight = table.heightAnchor.constraint(equalToConstant: table.contentSize.height)
    collectionViewHeight = collection.heightAnchor.constraint(equalToConstant: collection.contentSize.height)
    contentViewHeight = contentView.heightAnchor.constraint(
      equalToConstant: table.contentSize.height + collection.contentSize.height)
    
    tableViewHeight?.isActive = true
    collectionViewHeight?.isActive = true
    contentViewHeight?.isActive = true
    
    observeBag.append(
      table.observe(\.contentSize, options: [.new, .prior]) { (_, change) in
        if let height = change.newValue?.height, height != 0 {
          print("📌 TableView Height \(height)")
          self.tableViewHeight?.constant = height
//          self.contentViewHeight?.constant = height + self.collection.contentSize.height
          self.updateViewConstraints()
        }
      }
    )
    
    observeBag.append(
      collection.observe(\.contentSize, options: [.new, .prior], changeHandler: { (_, change) in
        if let height = change.newValue?.height, height != 0 {
          print("📌 CollectionView Height \(height)")
          self.collectionViewHeight?.constant = height
//          self.contentViewHeight?.constant = height + self.table.contentSize.height
          self.updateViewConstraints()
        }
      })
    )
  }
  
  #if DEBUG
  @objc func injected() {
    homeInject()
  }
  #endif
}

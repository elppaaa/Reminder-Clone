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
  fileprivate var observeBag = [NSKeyValueObservation]()

  fileprivate var collectionViewHeight: NSLayoutConstraint?
  fileprivate var tableViewHeight: NSLayoutConstraint?
//  fileprivate var contentViewHeight: NSLayoutConstraint?
  
  fileprivate let scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: .infinite)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isScrollEnabled = true
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = false
//    scrollView.isPagingEnabled = true
    scrollView.bounces = true
    return scrollView
  }()
  
  fileprivate let contentView: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.clipsToBounds = true
    return v
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    title = nil
    navigationController?.navigationBar.prefersLargeTitles = false
    super.viewWillAppear(true)
  }
  
  override func viewDidLoad() {
    table.viewController = self
    view.backgroundColor = R.Color.applicationBackground
    defaultNavigationConfig()
    searchBarSetting()
    configLayout()
    super.viewDidLoad()
  }

  func searchBarSetting() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    
    navigationItem.searchController = controller
    navigationItem.searchController?.isActive = true
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  // MARK: - config Layout
  func configLayout() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(collection)
    contentView.addSubview(table)
    
    scrollView.contentOffset = .init(x: 0, y: -20)
    
		NSLayoutConstraint.activate([
      // View - ScrollView
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      
      scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor),
      scrollView.frameLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      scrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      
      scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor),
      scrollView.contentLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
      scrollView.contentLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),

      // scrollView - contentView
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      // content - collection
      collection.topAnchor.constraint(equalTo: contentView.topAnchor),
      collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: table.adjustedContentInset.left),
      collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      table.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 10),
      table.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      table.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
    
		tableViewHeight = table.heightAnchor.constraint(equalToConstant: 0)
    collectionViewHeight = collection.heightAnchor.constraint(equalToConstant: 0)

    collectionViewHeight?.isActive = true
    tableViewHeight?.isActive = true

    observeBag.append(table.observe(\.contentSize, options: [.new, .prior]) { [weak self] _, newVal in
      if let height = newVal.newValue?.height, height != 0 {
        self?.tableViewHeight?.constant = height
        self?.updateViewConstraints()
      }
    })

    observeBag.append(collection.observe(\.contentSize, options: [.new, .prior]) { [weak self] _, newVal in
      if let height = newVal.newValue?.height, height != 0 {
        self?.collectionViewHeight?.constant = height
        self?.updateViewConstraints()
      }
    })

  }
  
  #if DEBUG
  @objc func injected() {
    homeInject()
  }
  #endif
}

//
//  MenuViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/8/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let modelTableVM = MenuTableViewVM.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
  }
  
  func setupTableView() {
    tableView.tableFooterView = UIView()
//    tableView.rowHeight = UITableViewAutomaticDimension
//    tableView.estimatedRowHeight = 150
  }
  
}

extension MenuViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelTableVM.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ModelTableViewCell.self), for: indexPath) as! ModelTableViewCell
    return cell
  }
  
}

extension MenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? ModelTableViewCell else { return }
    tableViewCell.setCollectionViewDataSourceDelegate(vc: self, forIndexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.row == 0 ? 180 : 120
  }
  
}

extension MenuViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let drinks = modelTableVM.getAllAvailabelModels().filter { $0.category == .drinks }
    return drinks.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModelCollectionViewCell.self), for: indexPath) as! ModelCollectionViewCell
//    cell.
    return cell
  }
  
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    guard let cell = collectionView.superview!.superview as? ModelTableViewCell else { return CGSize.zero }
//    guard let row = tableView.indexPath(for: cell)?.row else { return CGSize.zero }
//    let drinks = MenuTableViewModel.models.filter { $0.category == .drinks }
//    return row == 0 ? CGSize(width: 200, height: 180) : CGSize(width: 120, height: 120)
//  }
  
}


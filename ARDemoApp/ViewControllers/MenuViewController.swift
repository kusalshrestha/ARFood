//
//  MenuViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/8/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet var menuTableVM: MenuTableViewVM!
  @IBOutlet weak var tableView: UITableView!

  var modelSelection: ((VirtualObject) -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
  }
  
  func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 150
  }
  
}

extension MenuViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuTableVM.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ModelTableViewCell.self), for: indexPath) as! ModelTableViewCell
    cell.titile.text = menuTableVM.getHeaderTitleForIndexPath(indexpath: indexPath)
    cell.modelSelection = modelSelection
    return cell
  }
  
}

extension MenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? ModelTableViewCell else { return }
    tableViewCell.setCollectionViewDataSourceDelegate(vc: self, forIndexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.row == 0 ? 200 : 156
  }
  
}

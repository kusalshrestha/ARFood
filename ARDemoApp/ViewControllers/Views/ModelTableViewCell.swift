//
//  ModelTableViewCell.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/10/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

class ModelTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titile: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let collectionViewVM = CollectionViewVM.sharedInstance
  
  var indexPathOfTableView: IndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    collectionView.backgroundColor = UIColor.white
  }
  
  func setCollectionViewDataSourceDelegate(vc: MenuViewController, forIndexPath indexPath: IndexPath) {
    guard let collectionView = collectionView else { return }
//    collectionView.register(ModelCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ModelCollectionViewCell.self))
    collectionView.dataSource = vc
    collectionView.delegate = vc
    indexPathOfTableView = indexPath
  }
  
}


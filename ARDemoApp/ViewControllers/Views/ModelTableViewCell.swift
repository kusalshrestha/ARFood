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
    collectionView.backgroundColor = UIColor.white
    selectionStyle = .none
  }
  
  func setCollectionViewDataSourceDelegate(vc: MenuViewController, forIndexPath indexPath: IndexPath) {
    guard let collectionView = collectionView else { return }
    collectionView.dataSource = self
    collectionView.delegate = self
    indexPathOfTableView = indexPath
  }
  
}

extension ModelTableViewCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let models = collectionViewVM.getModelsForIndexPath(indexpath: indexPathOfTableView!)//modelTableVM.getAllAvailabelModels().filter { $0.category == .drinks }
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModelCollectionViewCell.self), for: indexPath) as! ModelCollectionViewCell
    let model = collectionViewVM.getModelsForIndexPath(indexpath: indexPathOfTableView!)[indexPath.row]
    cell.imageView.image = model.image
    cell.priceLabel.text = model.price
    return cell
  }
  
}

extension ModelTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let row = indexPathOfTableView?.row
      return row == 0 ? CGSize(width: 240, height: 200) : CGSize(width: 80, height: 120)
    }
  
}


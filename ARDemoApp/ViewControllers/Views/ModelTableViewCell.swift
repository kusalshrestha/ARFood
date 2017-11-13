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
  
  let cellWidth = UIScreen.main.bounds.width * 0.75
  let collectionViewVM = CollectionViewVM.sharedInstance
  var indexPathOfTableView: IndexPath?
  var modelSelection: ((VirtualObject) -> ())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    collectionView.backgroundColor = UIColor.white
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
  }
  
  func setCollectionViewDataSourceDelegate(vc: MenuViewController, forIndexPath indexPath: IndexPath) {
    guard let collectionView = collectionView else { return }
    collectionView.dataSource = self
    collectionView.delegate = self
    indexPathOfTableView = indexPath
    collectionView.reloadData()
  }
  
}

extension ModelTableViewCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let models = collectionViewVM.getModelsForIndexPath(indexpath: indexPathOfTableView!)
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModelCollectionViewCell.self), for: indexPath) as! ModelCollectionViewCell
    let model = collectionViewVM.getModelsForIndexPath(indexpath: indexPathOfTableView!)[indexPath.row]
    cell.imageView.image = model.image
    cell.priceLabel.text = model.price
    let row = indexPathOfTableView?.row
    cell.setCornerRadius(isFirstCollectionView: row == 0)
    collectionView.isPagingEnabled = row == 0 ? true : false
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let model = collectionViewVM.getModelsForIndexPath(indexpath: indexPathOfTableView!)[indexPath.row]
    guard let modelSelection = modelSelection else { return }
    modelSelection(model)
  }
  
}

extension ModelTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let row = indexPathOfTableView?.row
      return row == 0 ? CGSize(width: cellWidth, height: 144) : CGSize(width: cellWidth / 3, height: 100)
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let row = indexPathOfTableView?.row
    return row == 0 ? CGSize(width: 20, height: 200) : CGSize.zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let row = indexPathOfTableView?.row
    return row == 0 ? CGSize(width: 20, height: 200) : CGSize.zero
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    var reuseId = ""
    switch kind {
    case UICollectionElementKindSectionHeader:
      reuseId = "reusableHeaderView"
    case UICollectionElementKindSectionFooter:
      reuseId = "reusableFooterView"
    default:
      return UICollectionReusableView()
    }
    let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseId, for: indexPath)
    return reusableView
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    let row = indexPathOfTableView?.row
    if row == 0 { collectionView.scrollViewWillBeginDragging(scrollView) }
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    let row = indexPathOfTableView?.row
    if row == 0 { collectionView.scrollViewWillBeginDecelerating(scrollView) }
  }
  
}

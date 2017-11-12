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
  
  let cellWidth = UIScreen.main.bounds.width * 0.86
  let collectionViewVM = CollectionViewVM.sharedInstance
  var indexPathOfTableView: IndexPath?
  
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

var contentOffsetXWhileDragBegin: CGFloat = 0
var currentIndexPath: IndexPath?

extension ModelTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let row = indexPathOfTableView?.row
      return row == 0 ? CGSize(width: cellWidth, height: 200) : CGSize(width: 80, height: 120)
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: 20, height: 200)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: 20, height: 200)
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
  
  //case for scroll
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    let contentOffSetXOnDeccelerate = scrollView.contentOffset.x
    if let indexPath = currentIndexPath {
      if (contentOffSetXOnDeccelerate - contentOffsetXWhileDragBegin) > 0 {
        print("left")
        if indexPath.row < (collectionView.numberOfItems(inSection: 0) - 1) {
          let newRow = indexPath.row + 1
          let indexPath = IndexPath(item: newRow, section: 0)
          collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      } else {
        print("right")
        if indexPath.row > 0 {
          let newRow = indexPath.row - 1
          let indexPath = IndexPath(item: newRow, section: 0)
          collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      }
//      let row = Int(scrollView.contentOffset.x / cellWidth)
//      let indexPath = IndexPath(item: newRow, section: 0)
//      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
  }
  
  // Case for drag
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    contentOffsetXWhileDragBegin = scrollView.contentOffset.x
    currentIndexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.bounds.width / 2 + collectionView.contentOffset.x, y: 50))
  }
  
//  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////    let contentOffsetOnEndDrag = scrollView.contentOffset.x
//
//    let row = Int(scrollView.contentOffset.x / cellWidth)
//    let indexPath = IndexPath(item: row, section: 0)
//    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//  }
  
}


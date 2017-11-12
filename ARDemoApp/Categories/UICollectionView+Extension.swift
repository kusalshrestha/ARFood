//
//  SKCollectionView.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/12/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

private var contentOffsetXWhileDragBegin: CGFloat = 0
private var currentIndexPath: IndexPath?

extension UICollectionView {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    contentOffsetXWhileDragBegin = scrollView.contentOffset.x
    currentIndexPath = indexPathForItem(at: CGPoint(x: bounds.width / 2 + contentOffset.x, y: 50))
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    let contentOffSetXOnDeccelerate = scrollView.contentOffset.x
    if let indexPath = currentIndexPath {
      if (contentOffSetXOnDeccelerate - contentOffsetXWhileDragBegin) > 0 {
        if indexPath.row < (numberOfItems(inSection: 0) - 1) {
          let newRow = indexPath.row + 1
          let indexPath = IndexPath(item: newRow, section: 0)
          scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      } else {
        if indexPath.row > 0 {
          let newRow = indexPath.row - 1
          let indexPath = IndexPath(item: newRow, section: 0)
          scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      }
    }
  }
  
}

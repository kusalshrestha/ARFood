//
//  ModelCollectionViewCell.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/10/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

class ModelCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setCornerRadius(isFirstCollectionView: Bool = false) {
    layer.cornerRadius = isFirstCollectionView ? 8 : 5
//    imageView.layer.cornerRadius = isFirstCollectionView ? 8 : 4
  }
  
}

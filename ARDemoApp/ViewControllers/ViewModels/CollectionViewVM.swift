//
//  CollectionViewVM.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/11/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewVM: NSObject {
  
  static var sharedInstance = CollectionViewVM()
    
  private override init() {
    super.init()
  }
  
  func getModelsForIndexPath(indexpath: IndexPath) -> [ModelObject] {
    let models = ModelObject.getAllModels().filter { $0.category == ModelObject.modelCategoryList()[indexpath.row] }
    return models
  }
  
//  func getImageForIndexPath(indexPath: IndexPath) -> UIImage {
//    
//  }
  
}

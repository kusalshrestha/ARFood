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
  
  func getModelsForIndexPath(indexpath: IndexPath) -> [VirtualObject] {
    let models = VirtualObject.getAllModels().filter { $0.category == VirtualObject.modelCategoryList()[indexpath.row] }
    return models
  }
  
}

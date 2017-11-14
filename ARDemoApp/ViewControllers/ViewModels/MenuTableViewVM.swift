//
//  MenuViewModel.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/10/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewVM: NSObject {
    
  private override init() {
    super.init()
  }
  
  func getAllAvailabelModels() -> [ModelObject] {
    return ModelObject.getAllModels()
  }
  
  func numberOfRows() -> Int {
    return ModelObject.modelCategoryList().count
  }
  
  func getHeaderTitleForIndexPath(indexpath: IndexPath) -> String {
    return ModelObject.modelCategoryList()[indexpath.row].getTitle().capitalized
  }
  
}

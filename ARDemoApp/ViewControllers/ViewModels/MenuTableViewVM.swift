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
  
//  static var sharedInstance = MenuTableViewVM()
  
  private override init() {
    super.init()
  }
  
  func getAllAvailabelModels() -> [VirtualObject] {
    return VirtualObject.getAllModels()
  }
  
  func numberOfRows() -> Int {
    return VirtualObject.modelCategoryList().count
  }
  
  func getHeaderTitleForIndexPath(indexpath: IndexPath) -> String {
    return VirtualObject.modelCategoryList()[indexpath.row].getTitle().capitalized
  }
  
}

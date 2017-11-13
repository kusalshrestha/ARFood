//
//  SCNNode+Extension.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/13/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
  
  func clearChildNode() {
    for node in childNodes {
      node.removeFromParentNode()
    }
  }
  
  class func animateWithDuration(duration: TimeInterval, animation: () -> Void, completion: (() -> Void)?) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = duration
    SCNTransaction.completionBlock = completion
    animation()
    SCNTransaction.commit()
  }
  
}

//
//  SCNNode+Extension.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/13/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension SCNNode {
  
  func clearChildNode() {
    for node in childNodes {
      node.removeFromParentNode()
    }
  }
  
  func rotateModel(repeatCount: Float = .infinity) {
    let spin = CABasicAnimation(keyPath: "rotation")
    spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
    spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(Double.pi * 2))))
    spin.duration = 3
    spin.repeatCount = repeatCount
    addAnimation(spin, forKey: "spin around")
  }
  
  class func animateWithDuration(duration: TimeInterval, animation: () -> Void, completion: (() -> Void)?) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = duration
    SCNTransaction.completionBlock = completion
    animation()
    SCNTransaction.commit()
  }
  
}

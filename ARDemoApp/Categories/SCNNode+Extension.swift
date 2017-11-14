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
  
  class func animateWithDuration(duration: TimeInterval, animation: () -> Void, completion: (() -> Void)?) {
    SCNTransaction.begin()
    SCNTransaction.animationDuration = duration
    SCNTransaction.completionBlock = completion
    animation()
    SCNTransaction.commit()
  }
  
  /// - Tag: AdjustOntoPlaneAnchor
  func adjustOntoPlaneAnchor(_ anchor: ARPlaneAnchor, using node: SCNNode) {
    // Get the object's position in the plane's coordinate system.
    let planePosition = node.convertPosition(position, from: parent)
    
    // Check that the object is not already on the plane.
    guard planePosition.y != 0 else { return }
    
    // Add 10% tolerance to the corners of the plane.
    let tolerance: Float = 0.1
    
    let minX: Float = anchor.center.x - anchor.extent.x / 2 - anchor.extent.x * tolerance
    let maxX: Float = anchor.center.x + anchor.extent.x / 2 + anchor.extent.x * tolerance
    let minZ: Float = anchor.center.z - anchor.extent.z / 2 - anchor.extent.z * tolerance
    let maxZ: Float = anchor.center.z + anchor.extent.z / 2 + anchor.extent.z * tolerance
    
    guard (minX...maxX).contains(planePosition.x) && (minZ...maxZ).contains(planePosition.z) else {
      return
    }
    
    // Move onto the plane if it is near it (within 5 centimeters).
    let verticalAllowance: Float = 0.05
    let epsilon: Float = 0.001 // Do not update if the difference is less than 1 mm.
    let distanceToPlane = abs(planePosition.y)
    if distanceToPlane > epsilon && distanceToPlane < verticalAllowance {
      SCNTransaction.begin()
      SCNTransaction.animationDuration = CFTimeInterval(distanceToPlane * 500) // Move 2 mm per second.
      SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      position.y = anchor.transform.columns.3.y
      SCNTransaction.commit()
    }
  }
  
}

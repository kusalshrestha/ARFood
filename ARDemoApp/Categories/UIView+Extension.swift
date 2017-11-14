//
//  UIView+Extension.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/2/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum AnimatableSide {
  case left, right, top, bottom
}

let screenFrame = UIScreen.main.bounds

extension UIView {
  
  var globalPoint :CGPoint? {
    return self.superview?.convert(self.frame.origin, to: nil)
  }
  
  var globalFrame :CGRect? {
    return self.superview?.convert(self.frame, to: nil)
  }
  
  func animateComponent(from side: AnimatableSide, with delay: TimeInterval) {
    var startingPosition = CGPoint.zero
    let actualPosition = self.frame.origin
    guard let selfGlobalPoint = self.globalPoint else { return }

    switch side {
    case .left:
      startingPosition = CGPoint(x: -selfGlobalPoint.x - self.bounds.width, y: 0)
      
    case .top:
      startingPosition = CGPoint(x: -selfGlobalPoint.y - self.bounds.height, y: 0)

    case .right:
      startingPosition = CGPoint(x: screenFrame.maxX + self.bounds.width, y: 0)

    case .bottom:
      startingPosition = CGPoint(x: screenFrame.maxY + self.bounds.height, y: 0)

    }
    self.frame.origin = startingPosition
    UIView.animate(withDuration: 0.25, delay: delay, usingSpringWithDamping: 0.25, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      // animation code
      self.frame.origin = actualPosition
    }) { (completed) in
      // compltion block
    }
  }
  
}

extension ARSCNView {
  
  func takeScreeShot() {
    UIImageWriteToSavedPhotosAlbum(self.snapshot(), nil, nil, nil)
    DispatchQueue.main.async {
      // Briefly flash the screen.
      let flashOverlay = UIView(frame: self.frame)
      flashOverlay.backgroundColor = UIColor.white
      self.addSubview(flashOverlay)
      UIView.animate(withDuration: 0.25, animations: {
        flashOverlay.alpha = 0.0
      }, completion: { _ in
        flashOverlay.removeFromSuperview()
      })
    }
  }
  
}

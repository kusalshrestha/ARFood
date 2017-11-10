//
//  AnimationUtil.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/8/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import UIKit

enum Side {
  case left, right, top, bottom
}

func toggleAnimation(ofSide side: Side, toShow show: Bool, delayBetweenAnimation delay: TimeInterval, animatingViews views: [UIView]) {
  
  func animationView(view: UIView, delay: TimeInterval, position: CGPoint, completion: ((Bool) -> Swift.Void)? = nil) {
    UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseInOut, animations: {
      view.frame.origin = position
    }, completion: completion)
  }
  
  for view in views {
    var newPsition = CGPoint.zero
    switch side {
    case .left:
      newPsition = CGPoint(x: view.frame.minX - view.frame.maxX, y: view.frame.midY)
    case .right:
      newPsition = CGPoint(x: view.frame.maxX + view.frame.width, y: view.frame.midY)
    case .top:
      newPsition = CGPoint(x: view.frame.midX, y: view.frame.maxY - view.frame.minY)
    case .bottom:
      newPsition = CGPoint(x: view.frame.midX, y: view.frame.maxY + view.frame.height)
    }

    animationView(view: view, delay: 0, position: newPsition, completion: nil)
  }
}

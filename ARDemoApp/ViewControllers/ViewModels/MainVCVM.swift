//
//  MainVCVM.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/13/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class MainViewControllerVM: NSObject {
  
  var focusSquare = FocusSquare()

  override init() {
    super.init()
  }
  
  func configureScene(ARSceneView: VirtualObjectARView, delegate vc: ViewController) {
    ARSceneView.delegate = vc
    ARSceneView.session.delegate = vc
    //    ARsceneView.showsStatistics = true
    ARSceneView.automaticallyUpdatesLighting = true
    ARSceneView.antialiasingMode = .multisampling4X
    UIApplication.shared.isStatusBarHidden = true
    UIApplication.shared.isIdleTimerDisabled = true
    
    ARSceneView.scene.rootNode.addChildNode(focusSquare)
  }
  
  func runARSession(ARSceneView: VirtualObjectARView) {
    if !ARWorldTrackingConfiguration.isSupported { return }
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = .horizontal
    config.worldAlignment = .gravityAndHeading
    config.isLightEstimationEnabled = true
    ARSceneView.session.run(config, options: [])
  }
  
}

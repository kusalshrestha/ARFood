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
  
  let scene = SCNScene()
  var isSurfaceDetected = false

  override init() {
    super.init()
  }
  
  // Should not think this should be here
  func configureScene(ARSceneView: VirtualObjectARView, delegate vc: ViewController) {
    ARSceneView.delegate = vc
    ARSceneView.session.delegate = vc
    //    ARsceneView.showsStatistics = true
    ARSceneView.automaticallyUpdatesLighting = true
    ARSceneView.antialiasingMode = .multisampling4X
    UIApplication.shared.isStatusBarHidden = true
    UIApplication.shared.isIdleTimerDisabled = true
    
    ARSceneView.scene = scene
  }
  
  func runARSession(ARSceneView: VirtualObjectARView) {
    if !ARWorldTrackingConfiguration.isSupported { return }
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = .horizontal
    config.worldAlignment = .gravityAndHeading
    config.isLightEstimationEnabled = true
    ARSceneView.session.run(config, options: [.resetTracking])
  }
  
  func getMessageAccordingToARState(for frame: ARFrame, trackingState: ARCamera.TrackingState) -> String {
    let message: String
    
    switch trackingState {
    case .normal where frame.anchors.isEmpty:
      message = "Move the device around to detect horizontal surfaces. 👈"
      isSurfaceDetected = false

    case .normal:
      message = "Well Done 👏"
      isSurfaceDetected = true
      
    case .notAvailable:
      message = "😔 Tracking unavailable."
      isSurfaceDetected = false

    case .limited(.excessiveMotion):
      message = "Tracking limited - Move the device more slowly. 🐢"
      isSurfaceDetected = false

    case .limited(.insufficientFeatures):
      message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions. 💡"
      isSurfaceDetected = false

    case .limited(.initializing):
      message = "👉 Initializing AR session."
      isSurfaceDetected = false
    }
    return message
  }
  
  func addSpotLightOnNode(rootNode: SCNNode) {
    let secondaryLightSource = SCNLight()
    secondaryLightSource.castsShadow = true
    secondaryLightSource.intensity = 750
    secondaryLightSource.type = .ambient
    let secondaryLightNode = SCNNode()
    secondaryLightNode.light = secondaryLightSource
    secondaryLightNode.position = SCNVector3(x: 0, y: 250, z: 0)
    rootNode.addChildNode(secondaryLightNode)
    
    let primaryLightSource = SCNLight()
    primaryLightSource.castsShadow = true
    primaryLightSource.type = .spot
    primaryLightSource.shadowRadius = 20;
    primaryLightSource.shadowSampleCount = 50;
    let primaryLightNode = SCNNode()
    primaryLightNode.light = primaryLightSource
    primaryLightNode.position = SCNVector3(x: 0, y: 15, z: 0)
    
    primaryLightNode.eulerAngles.x = -.pi / 2
    rootNode.addChildNode(primaryLightNode)
  }
  
}

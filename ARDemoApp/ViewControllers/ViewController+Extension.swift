//
//  ViewController+Extension.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/14/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

// MARK: - ARSCNViewDelegate + ARSessionDelegate
extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
  
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }
  
  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
      self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
      self.updateFocusSquare()
    }
    
    // If light estimation is enabled, update the intensity of the model's lights and the environment map
    let baseIntensity: CGFloat = 40
    let lightingEnvironment = ARsceneView.scene.lightingEnvironment
    if let lightEstimate = ARsceneView.session.currentFrame?.lightEstimate {
      lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
    } else {
      lightingEnvironment.intensity = baseIntensity
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    updateQueue.async {
      for object in self.virtualObjectLoader.loadedObjects {
        object.adjustOntoPlaneAnchor(planeAnchor, using: node)
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    updateQueue.async {
      for object in self.virtualObjectLoader.loadedObjects {
        object.adjustOntoPlaneAnchor(planeAnchor, using: node)
      }
    }
  }
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    guard let frame = session.currentFrame else { return }
    updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    guard error is ARError else { return }
    print(error.localizedDescription)
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    ARStatusLabel.text = "Session Interrupted 😞"
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    ARStatusLabel.text = "Session Interruption Ended 😃"
  }
  
}

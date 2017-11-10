//
//  ViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 10/18/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Photos

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
  
  @IBOutlet weak var ARsceneView: VirtualObjectARView!
  @IBOutlet weak var ARStatusLabel: UILabel!
  @IBOutlet weak var ARInfoView: UIVisualEffectView!
  @IBOutlet weak var starrerBlurView: UIVisualEffectView!
  
  @IBOutlet weak var reloadButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!
  
  var focusSquare = FocusSquare()

  var screenCenter: CGPoint {
    let bounds = ARsceneView.bounds
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }

  /// A serial queue used to coordinate adding or removing nodes from the scene.
  let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupScene()
  }
  
  func setupScene() {
    ARsceneView.delegate = self
    ARsceneView.session.delegate = self
//    ARsceneView.showsStatistics = true
    ARsceneView.automaticallyUpdatesLighting = true
    ARsceneView.antialiasingMode = .multisampling4X
    UIApplication.shared.isStatusBarHidden = true
    UIApplication.shared.isIdleTimerDisabled = true
    
    ARsceneView.scene.rootNode.addChildNode(focusSquare)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !ARWorldTrackingConfiguration.isSupported { return }
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = .horizontal
    config.worldAlignment = .gravityAndHeading
    config.isLightEstimationEnabled = true
    ARsceneView.session.run(config, options: [])
    
    // Fadeoff StarrerBlurView
    UIView.animate(withDuration: 0.25) {
      self.starrerBlurView.effect = nil
    }
    
    let sphereGeometry = SCNSphere(radius: 10)
    let node = SCNNode(geometry: sphereGeometry)
    node.position = SCNVector3(x: 0, y: 0, z: 0)
    sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red
    ARsceneView.scene.rootNode.addChildNode(node)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
//    toggleAnimation(ofSide: .bottom, toShow: false, delayBetweenAnimation: 0.1, animatingViews: [reloadButton, addButton, cameraButton])
  }
  
  @IBAction func dismissMenuVC(segue: UIStoryboardSegue) {
//    toggleAnimation(ofSide: .bottom, toShow: true, delayBetweenAnimation: 0.1, animatingViews: [reloadButton, addButton, cameraButton])
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Fadeon StarrerBlurView
    UIView.animate(withDuration: 0.25) {
      self.starrerBlurView.effect = UIBlurEffect(style: .prominent)
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    ARsceneView.session.pause()
  }
  
  private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
    let message: String
    
    switch trackingState {
    case .normal where frame.anchors.isEmpty:
      message = "Move the device around to detect horizontal surfaces."
      
    case .normal:
      message = "Bingo"
      
    case .notAvailable:
      message = "Tracking unavailable."
      
    case .limited(.excessiveMotion):
      message = "Tracking limited - Move the device more slowly."
      
    case .limited(.insufficientFeatures):
      message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
      
    case .limited(.initializing):
      message = "Initializing AR session."
    }
    
    ARStatusLabel.text = message
    ARInfoView.isHidden = message.isEmpty
  }
  
  @IBAction func reloadTrackingAndVisulization(_ sender: UIButton) {
    resetTracking()
  }
  
  @IBAction func pausePlay(_ sender: UIButton) {
    // TODO: implement it later
  }
  
  private func resetTracking() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    ARsceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }
  
  private func rotateModel(node: SCNNode) {
    let spin = CABasicAnimation(keyPath: "rotation")
    spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
    spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(Double.pi * 2))))
    spin.duration = 3
    spin.repeatCount = .infinity
    node.addAnimation(spin, forKey: "spin around")
  }
  
  @IBAction func takeScreenshot() {
    let takeScreenshotBlock = {
      UIImageWriteToSavedPhotosAlbum(self.ARsceneView.snapshot(), nil, nil, nil)
      DispatchQueue.main.async {
        // Briefly flash the screen.
        let flashOverlay = UIView(frame: self.ARsceneView.frame)
        flashOverlay.backgroundColor = UIColor.white
        self.ARsceneView.addSubview(flashOverlay)
        UIView.animate(withDuration: 0.25, animations: {
          flashOverlay.alpha = 0.0
        }, completion: { _ in
          flashOverlay.removeFromSuperview()
        })
      }
    }
    
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
      takeScreenshotBlock()
    case .restricted, .denied:
      let message = "Photos access denied"
      ARStatusLabel.text = message
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
        if authorizationStatus == .authorized {
          takeScreenshotBlock()
        }
      })
    }
  }
  
  func addSpotLightOnNode(node: SCNNode) {
    let light = SCNLight()
    light.castsShadow = true
    light.type = .omni
    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = SCNVector3(x: 0, y: 5, z: 0)
    node.addChildNode(lightNode)
  }
  
  // MARK: - Update focus square
  func updateFocusSquare() {
    let isObjectVisible = true
    
    if isObjectVisible {
      focusSquare.hide()
    } else {
      focusSquare.unhide()
//      statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }
    
    // We should always have a valid world position unless the sceen is just being initialized.
    guard let (worldPosition, planeAnchor, _) = ARsceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
      updateQueue.async {
        self.focusSquare.state = .initializing
        self.ARsceneView.pointOfView?.addChildNode(self.focusSquare)
      }
//      addObjectButton.isHidden = true
      return
    }
    
    updateQueue.async {
      self.ARsceneView.scene.rootNode.addChildNode(self.focusSquare)
      let camera = self.ARsceneView.session.currentFrame?.camera
      
      if let planeAnchor = planeAnchor {
        self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
      } else {
        self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
      }
    }
//    addObjectButton.isHidden = false
//    statusViewController.cancelScheduledMessage(for: .focusSquare)
  }
  
}

// MARK:- ARSCNViewDelegate
extension ViewController {
  
//  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {}
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    guard let carScene = SCNScene(named: "Food.scnassets/Cocacola/model.dae") else { return }
    guard let carNode = carScene.rootNode.childNode(withName: "SketchUp", recursively: false) else { return }
//    guard let platformNode = carScene.rootNode.childNode(withName: "platform", recursively: false) else { return }
    let modelNode = SCNNode()
    modelNode.addChildNode(carNode)
//    modelNode.addChildNode(platformNode)
    modelNode.scale = SCNVector3(x: 0.02, y: 0.02, z: 0.02)
    modelNode.simdPosition = float3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//    modelNode.eulerAngles = SCNVector3Make(Float(Double.pi / 2), 0, 0)
    node.addChildNode(modelNode)
    rotateModel(node: modelNode)
  }
  
}

// MARK: - ARSessionDelegate
extension ViewController {
  
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }
  
  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
//      self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
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

}

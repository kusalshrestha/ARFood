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
  
  @IBOutlet var menuViewModel: NSObject!
  
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
    guard let menuVC = segue.destination as? MenuViewController else { return }
    menuVC.modelSelection = { model in
      print(model.displayName)
      menuVC.dismiss(animated: true, completion: nil)
    }
    
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

// MARK:- ARSCNViewDelegate
extension ViewController {
  
//  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {}
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    guard let carScene = SCNScene(named: "Places.scnassets/Boudha/model.dae") else { return }
    guard let carNode = carScene.rootNode.childNode(withName: "SketchUp", recursively: false) else { return }
//    guard let platformNode = carScene.rootNode.childNode(withName: "platform", recursively: false) else { return }
    let modelNode = SCNNode()
    modelNode.addChildNode(carNode)
//    modelNode.addChildNode(platformNode)
    modelNode.scale = SCNVector3(x: 0.0001, y: 0.0001, z: 0.0001)
//    modelNode.simdPosition = float3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//    modelNode.eulerAngles = SCNVector3Make(Float(Double.pi / 2), 0, 0)
    node.addChildNode(modelNode)
    addSpotLightOnNode(rootNode: node)
//    rotateModel(node: modelNode)
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

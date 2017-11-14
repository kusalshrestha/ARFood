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

class ViewController: UIViewController {
  
  private let buttonShowConstraint: CGFloat = 16
  private let buttonHideConstraint: CGFloat = -60
  
  @IBOutlet weak var whiteBackGroundView: UIView!
  @IBOutlet weak var logoImageView: UIImageView!

  @IBOutlet var mainVCVM: MainViewControllerVM!
  @IBOutlet weak var ARsceneView: VirtualObjectARView!
  @IBOutlet weak var ARStatusLabel: UILabel!
  @IBOutlet weak var ARInfoView: UIVisualEffectView!
  @IBOutlet weak var starrerBlurView: UIVisualEffectView!
  
  @IBOutlet weak var reloadButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!

  @IBOutlet var constraints: [NSLayoutConstraint]!

  var focusSquare = FocusSquare()

  var screenCenter: CGPoint {
    let bounds = ARsceneView.bounds
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }

  /// A serial queue used to coordinate adding or removing nodes from the scene.
  let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainVCVM.configureScene(ARSceneView: ARsceneView, delegate: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //hide all buttons, shows when surface is detected
    buttonsHideShowAnimation(toShow: false, animationTime: 0, andDelay: 0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    logoAnimationWithCompletion {
      self.showHideBlurOverlay(show: false)
      self.mainVCVM.runARSession(ARSceneView: self.ARsceneView)
    }
  }
  
  //MARK:-  Animation logo Animation ladder
  private func logoAnimationWithCompletion(animationCompletion: @escaping () -> ()) {
    UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseInOut, animations: {
      self.logoImageView.alpha = 1
    }) { (completed) in
      UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseInOut, animations: {
        self.logoImageView.alpha = 0
      }, completion: { (completed) in
        UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseInOut, animations: {
          self.whiteBackGroundView.alpha = 0
        }, completion: { (completed) in
          self.whiteBackGroundView.removeFromSuperview()
          animationCompletion()
        })
      })
    }
  }
  
  private func buttonsHideShowAnimation(toShow: Bool, animationTime time: TimeInterval, andDelay delay: TimeInterval, completion: (() -> ())? = nil) {
    let newConstraint = toShow ? buttonShowConstraint : buttonHideConstraint
    var delay = delay
    for constraint in constraints {
      constraint.constant = newConstraint
      view.setNeedsUpdateConstraints()
      UIView.animate(withDuration: time, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
        self?.view.layoutIfNeeded()
      }, completion: { [weak self] (completed) in
        if (self?.constraints.index(of: constraint) == (self?.constraints.count)! - 1) {
          completion?()
          print("completed")
        }
      })
      delay = delay + 0.1
    }
  }
  
  private func showHideBlurOverlay(show: Bool, completion: (() -> ())? = nil) {
    let alphaValue: CGFloat = show ? 1 : 0
    UIView.animate(withDuration: 1, animations: {
      self.starrerBlurView.alpha = alphaValue
    }) { (completed) in
      // completion block
      completion?()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    guard let menuVC = segue.destination as? MenuViewController else { return }
    showHideBlurOverlay(show: true)
    buttonsHideShowAnimation(toShow: false, animationTime: 0.3, andDelay: 0.25, completion: {
      menuVC.modelSelection = { model in
        print(model.displayName)
        menuVC.dismiss(animated: true, completion: nil)
        self.showHideBlurOverlay(show: false)
        self.buttonsHideShowAnimation(toShow: true, animationTime: 0.3, andDelay: 0.25)
      }
    })
  }
  
  @IBAction func dismissMenuVC(segue: UIStoryboardSegue) {
    self.showHideBlurOverlay(show: false)
    self.buttonsHideShowAnimation(toShow: true, animationTime: 0.3, andDelay: 0.25)
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
    let message = mainVCVM.getMessageAccordingToARState(for: frame, trackingState: trackingState)
    mainVCVM.isSurfaceDetected ? buttonsHideShowAnimation(toShow: true, animationTime: 0.3, andDelay: 0.25) : buttonsHideShowAnimation(toShow: false, animationTime: 0.3, andDelay: 0.25)
    ARStatusLabel.text = message
    ARInfoView.isHidden = message.isEmpty
  }
  
  @IBAction func reloadTrackingAndVisulization(_ sender: UIButton) {
    resetTracking()
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
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
      ARsceneView.takeScreeShot()
    case .restricted, .denied:
      let message = "Photos access denied"
      ARStatusLabel.text = message
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
        if authorizationStatus == .authorized {
          self.ARsceneView.takeScreeShot()
        }
      })
    }
  }
  
}

// MARK:- ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    return nil
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    let box = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0)
    box.firstMaterial?.diffuse.contents = UIColor.red
    let modelNode = SCNNode(geometry: box)
//    modelNode.scale = SCNVector3(x: 0.0001, y: 0.0001, z: 0.0001)
//    modelNode.simdPosition = float3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//    modelNode.eulerAngles = SCNVector3Make(Float(Double.pi / 2), 0, 0)
    node.addChildNode(modelNode)
    mainVCVM.scene.rootNode.addChildNode(modelNode)
    mainVCVM.addSpotLightOnNode(rootNode: node)
//    rotateModel(node: modelNode)
  }
  
}

// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {
  
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

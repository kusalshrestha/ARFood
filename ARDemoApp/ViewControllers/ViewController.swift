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

  var placeholderNode: SCNNode?
  var lastModel: SCNNode = SCNNode()
  var splitVC: SplitViewController?
  
  var focusSquare = FocusSquare()
  lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: ARsceneView)
  let virtualObjectLoader = VirtualObjectLoader()

  /// A serial queue used to coordinate adding or removing nodes from the scene.
  let updateQueue = DispatchQueue(label: "com.leapfrog.ARserialSceneKitQueue")

  var screenCenter: CGPoint {
    let bounds = ARsceneView.bounds
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }

  // MARK:- VIEW LIFECYCLES
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainVCVM.configureScene(ARSceneView: ARsceneView, delegate: self)
    setupCamera()
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
  
  func setupCamera() {
    guard let camera = ARsceneView.pointOfView?.camera else {
      fatalError("Expected a valid `pointOfView` from the scene.")
    }
    
    /*
     Enable HDR camera settings for the most realistic appearance
     with environmental lighting and physically based materials.
     */
    camera.wantsHDR = true
    camera.exposureOffset = -1
    camera.minimumExposure = -1
    camera.maximumExposure = 3
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
//          print("completed")
        }
      })
      delay = delay + 0.1
    }
  }
  
  private func makeVibration() {
    DispatchQueue.main.async {
      let generator = UIImpactFeedbackGenerator(style: .heavy)
      generator.prepare()
      generator.impactOccurred()
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

  func placeVirtualObject(_ virtualObject: VirtualObject) {
    guard let cameraTransform = ARsceneView.session.currentFrame?.camera.transform,
      let focusSquarePosition = focusSquare.lastPosition else { return }
    
    virtualObjectInteraction.selectedObject = virtualObject
    virtualObject.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
    
    updateQueue.async {
      self.ARsceneView.scene.rootNode.addChildNode(virtualObject)
    }
  }
  
  @IBAction func addButtonOnPress(_ sender: UIButton) {
    splitVC = UIViewController.instantiate(vc: SplitViewController.self)
    buttonsHideShowAnimation(toShow: false, animationTime: 0.3, andDelay: 0.25)
    showHideBlurOverlay(show: true, completion: { [weak self] in
      self?.present((self?.splitVC)!, animated: true, completion: nil)
    })

    splitVC?.menuVC.delegate = self
    splitVC?.dismissViewCallback = closeSplitVC
  }
  
  func closeSplitVC() {
    splitVC?.dismiss(animated: true, completion: nil)
    self.buttonsHideShowAnimation(toShow: true, animationTime: 0.3, andDelay: 0.25)
    self.showHideBlurOverlay(show: false, completion: nil)
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
  
  func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
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
    self.virtualObjectLoader.removeAllVirtualObjects()
    ARsceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
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
  
  // MARK: - Focus Square
  func updateFocusSquare() {
    let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
      return ARsceneView.isNode(object, insideFrustumOf: ARsceneView.pointOfView!)
    }

    isObjectVisible ? focusSquare.hide() : focusSquare.unhide()
    // We should always have a valid world position unless the sceen is just being initialized.
    guard let (worldPosition, planeAnchor, _) = ARsceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
      updateQueue.async {
        self.focusSquare.state = .initializing
        self.ARsceneView.pointOfView?.addChildNode(self.focusSquare)
      }
      buttonsHideShowAnimation(toShow: false, animationTime: 0.25, andDelay: 0.1)
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
    buttonsHideShowAnimation(toShow: true, animationTime: 0.25, andDelay: 0.1)
  }
  
}

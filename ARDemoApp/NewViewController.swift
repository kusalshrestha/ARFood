//
//  NewViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/9/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class NewViewController: UIViewController {
  
  @IBOutlet weak var arView: ARSCNView!
  @IBOutlet weak var sceneView: SCNView!
  var scene: SCNScene!
  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//
//    if !ARWorldTrackingConfiguration.isSupported { return }
//    let config = ARWorldTrackingConfiguration()
//    config.planeDetection = .horizontal
//    config.worldAlignment = .gravityAndHeading
//    arView.session.run(config, options: [])
//  }

  
  func sceneSetup() {
    let scene = SCNScene()
    sceneView.scene = scene
  }
  
  override func loadView() {
    super.loadView()
    setupScene()
  }
  
  func setupScene() {
    scene = SCNScene()
    sceneView.scene = scene
//    arView.delegate = self
    sceneView.backgroundColor = UIColor.gray
    sceneView.showsStatistics = true
    sceneView.allowsCameraControl = true
    
//    setupLight()
//    setupBox()
    setupCamera()
    addAxisLine()
    insertObjects()
  }
  
  func addAxisLine() {
    let axis = AxisLine(lineWidth: 10000)
    let axisNode = axis.createAxes()
    axisNode.position = SCNVector3(x: 0, y: 0, z: 0)
    scene.rootNode.addChildNode(axisNode)
  }
  
  
  func setupBox() {
    let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
    box.firstMaterial?.diffuse.contents = UIColor.red
    let boxNode = SCNNode(geometry: box)
    boxNode.position = SCNVector3(x: 0, y: 0, z: 0)
    scene.rootNode.addChildNode(boxNode)
  }
  
  func insertObjects() {
    let breakFastModelNode = VirtualObject(model: .breakfast)
    let modelNode = breakFastModelNode.getModel()
    scene.rootNode.addChildNode(modelNode)
    print(modelNode.position)
  }
  
  func setupLight() {
    let light = SCNLight()
    light.castsShadow = true
    light.type = .omni
    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
    scene.rootNode.addChildNode(lightNode)
  }
  
  func setupCamera() {
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    cameraNode.camera = camera
    cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)
    scene.rootNode.addChildNode(cameraNode)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}


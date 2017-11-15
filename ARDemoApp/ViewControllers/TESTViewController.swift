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
//    sceneView.showsStatistics = true
    sceneView.allowsCameraControl = true
    sceneView.debugOptions = [.showCameras, .renderAsWireframe, .showCameras, .showCreases, .showLightExtents]
//    sceneView.debugOptions = .showLightExtents

    setupLight()
    setupBox()
    setupCamera()
//    addAxisLine()
//    insertObjects()
  }
  
  func addAxisLine() {
    let axis = AxisLine(lineWidth: 10000)
    let axisNode = axis.createAxes()
    axisNode.position = SCNVector3(x: 0, y: 0, z: 0)
    scene.rootNode.addChildNode(axisNode)
  }
  
  
  func setupBox() {
    let box = SCNSphere(radius: 1)//SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
    box.firstMaterial?.diffuse.contents = UIColor.red
    let boxNode = SCNNode(geometry: box)
    boxNode.position = SCNVector3(x: 0, y: 1, z: 0)
    scene.rootNode.addChildNode(boxNode)
    
    let plane = SCNFloor()
    let planeNode = SCNNode(geometry: plane)
    plane.firstMaterial?.diffuse.contents = UIColor.lightGray
    plane.reflectionFalloffEnd = 2
    scene.rootNode.addChildNode(planeNode)
  }
  
  func insertObjects() {
//    let breakFastModelNode = ModelObject(model: .cocacola)
//    let modelNode = breakFastModelNode.getModel()
//    scene.rootNode.addChildNode(modelNode)
//    print(modelNode.position)
  }
  
  func setupLight() {
    let light1 = SCNLight()
    light1.castsShadow = true
    light1.intensity = 250
    light1.type = .ambient
    let lightNode1 = SCNNode()
    lightNode1.light = light1
    lightNode1.position = SCNVector3(x: 0, y: 250, z: 0)
    scene.rootNode.addChildNode(lightNode1)

    let light2 = SCNLight()
    light2.castsShadow = true
    light2.type = .spot
    light2.shadowRadius = 20;
    light2.shadowSampleCount = 50;
    let lightNode2 = SCNNode()
    lightNode2.light = light2
    lightNode2.position = SCNVector3(x: 0, y: 15, z: 0)

    lightNode2.eulerAngles.x = -.pi / 2
    scene.rootNode.addChildNode(lightNode2)
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


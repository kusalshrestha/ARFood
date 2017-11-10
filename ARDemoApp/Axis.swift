
import Foundation
import SceneKit

enum Axis {
  case xAxis, yAxis, zAxis
  
  var color: UIColor {
    switch self {
    case .xAxis:
      return UIColor.red
      
    case .yAxis:
      return UIColor.blue
      
    case .zAxis:
      return UIColor.green
    }
  }
}

struct AxisLine {
  private var axisLength: Float
  
  init(lineWidth: Float = 100000) {
    axisLength = lineWidth
  }
  
  func createAxes() -> SCNNode {
    let axis = SCNNode()
    
    let xaxis = createAxis(axis: .xAxis)
    let yaxis = createAxis(axis: .yAxis)
    let zaxis = createAxis(axis: .zAxis)
    
    axis.addChildNode(xaxis)
    axis.addChildNode(yaxis)
    axis.addChildNode(zaxis)
    
    return axis
  }
  
  private func createAxis(axis: Axis) -> SCNNode {
    let point1: SCNVector3!
    let point2: SCNVector3!
    switch(axis) {
    case .xAxis:
      point1 = SCNVector3(axisLength, 0, 0)
      point2 = SCNVector3(-axisLength, 0, 0)
      break
      
    case .yAxis:
      point1 = SCNVector3(0, axisLength, 0)     //y
      point2 = SCNVector3(0, -axisLength, 0)    //-y
      break
      
    case .zAxis:
      point1 = SCNVector3(0, 0, axisLength)     //z
      point2 = SCNVector3(0, 0, -axisLength)    //-z
      break
    }
    
    let geometricSources: [SCNGeometrySource]     = generateGeometricSource(v1: point1, v2: point2)
    let geometricElements: [SCNGeometryElement]   = generateGeometricElement()
    
    // line node
    let geo = SCNGeometry(sources: geometricSources, elements: geometricElements)
    let line = SCNNode(geometry: geo)
    line.position = SCNVector3(x: 0, y: 0, z: 0)
    geo.firstMaterial?.diffuse.contents = axis.color
    return line
  }
  
  private func generateGeometricSource(v1: SCNVector3, v2: SCNVector3) -> [SCNGeometrySource] {
    // vertex buffer
    let point1 = v1
    let point2 = v2
    
    let vertices: [SCNVector3] = [point1, point2]
    let geometricSource = SCNGeometrySource(vertices: vertices)
    return [geometricSource]
  }
  
  private func generateGeometricElement() -> [SCNGeometryElement] {
    // index buffer
    let idx: [Int32] = [0, 1]
    let data = NSData(bytes: idx, length: MemoryLayout<Int32>.size * idx.count)
    let geoElements = SCNGeometryElement(data: data as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx.count, bytesPerIndex: MemoryLayout<Int32>.size)
    return [geoElements]
  }
}


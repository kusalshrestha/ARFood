//
//  VirtualObject.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/9/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit

class VirtualObject {
  
  var category: Category!
  var model: ArtificialModel!
  var displayName: String!
  var modelNode: SCNNode!
  var icon: String!
  var image: UIImage!
  var price: String!
  
  init(model: ArtificialModel) {
    self.model = model
    categorizeModels()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func categorizeModels() {
    switch model {
    case .aarquiteta:
      displayName = "Aarquiteta"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "Lemonade.jpeg")
      price = "$ 9.9"
    case .bierfles:
      displayName = "Bierfles"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "Bierfles.jpeg")
      price = "$ 9.9"
    case .birthdayCake:
      displayName = "Birthday Cake"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "BirthdayCake.jpg")
      price = "$ 9.9"
    case .breakfast:
      displayName = "Breakfast"
      category = .breakfast
      icon = ""
      image = #imageLiteral(resourceName: "BreakFast.jpg")
      price = "$ 9.9"
    case .blackforest:
      displayName = "Black Forest"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "BlackForestCake.jpg")
      price = "$ 9.9"
    case .burger:
      displayName = "Burger"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "Burger.jpg")
      price = "$ 9.9"
    case .burgerFries:
      displayName = "Burger & Fries"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "BurgerFries.jpg")
      price = "$ 9.9"
    case .cakePiece:
      displayName = "Cake Piece"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "CakePiece.jpg")
      price = "$ 9.9"
    case .chineseNoodles:
      displayName = "Haka Noodles"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "InstantNoodles.jpg")
      price = "$ 9.9"
    case .chocolateCake:
      displayName = "Chocolate Cake"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "ChocolateCake.jpg")
      price = "$ 9.9"
    case .clicquot:
      displayName = "Clicquot"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "Clicquot.jpg")
      price = "$ 9.9"
    case .cocacola:
      displayName = "Cocacola"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "Cocacola.jpg")
      price = "$ 9.9"
    case .fastFood:
      displayName = "Fast Food"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "FastFood.jpg")
      price = "$ 9.9"
    case .franksBeansDinner:
      displayName = "Franks Beans Dinner"
      category = .other
      icon = ""
      image = #imageLiteral(resourceName: "FranksBeansDinner.jpg")
      price = "$ 9.9"
    case .giapponese:
      displayName = "Giapponese"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Giapponese.jpg")
      price = "$ 9.9"
    case .instantNodoles:
      displayName = "Noodles"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Noodles.jpg")
      price = "$ 9.9"
    case .jackDaniels:
      displayName = "Jack Daniels"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "JackDaniels.jpg")
      price = "$ 9.9"
    case .oskarBluesBeer:
      displayName = "Oskar Blues Beer"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "OskarBlues.jpg")
      price = "$ 9.9"
    case .pepperoniPizza:
      displayName = "Pepperoni Pizza"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "PepperoniPizza.jpg")
      price = "$ 9.9"
    case .potatoChips:
      displayName = "Potato Chips"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "PotatoChips.jpg")
      price = "$ 9.9"
    case .senzaTitolo:
      displayName = "Senza Titolo"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "HotDog.jpg")
      price = "$ 9.9"
    case .soup:
      displayName = "Soup"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Soup.jpg")
      price = "$ 9.9"
    case .sucos:
      displayName = "Sucos"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Sucos.jpg")
      price = "$ 9.9"
    case .weddingCake:
      displayName = "Wedding Cake"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "WeddingCake.jpg")
      price = "$ 9.9"
    case .none:
      break
    case .some(_):
      break
    }
  }
  
  func getModel() -> SCNNode {
    let modelScene = SCNScene(named: model.modelsPath() + "/model.dae")
    guard let scene = modelScene else { return SCNNode() }
    guard let modelNode = scene.rootNode.childNode(withName: "SketchUp", recursively: false) else { return SCNNode() }
    self.modelNode = modelNode
    return modelNode
  }
  
  class func getAllModels() -> [VirtualObject] {
    var models: [VirtualObject] = []
    
    models.append(VirtualObject(model: .aarquiteta))
    models.append(VirtualObject(model: .bierfles))
    models.append(VirtualObject(model: .birthdayCake))
    models.append(VirtualObject(model: .blackforest))
    models.append(VirtualObject(model: .breakfast))
    models.append(VirtualObject(model: .burger))
    models.append(VirtualObject(model: .burgerFries))
    models.append(VirtualObject(model: .cakePiece))
    models.append(VirtualObject(model: .chineseNoodles))
    models.append(VirtualObject(model: .chocolateCake))
    models.append(VirtualObject(model: .clicquot))
    models.append(VirtualObject(model: .cocacola))
    models.append(VirtualObject(model: .fastFood))
    models.append(VirtualObject(model: .franksBeansDinner))
    models.append(VirtualObject(model: .giapponese))
    models.append(VirtualObject(model: .instantNodoles))
    models.append(VirtualObject(model: .jackDaniels))
    models.append(VirtualObject(model: .oskarBluesBeer))
    models.append(VirtualObject(model: .pepperoniPizza))
    models.append(VirtualObject(model: .potatoChips))
    models.append(VirtualObject(model: .soup))
    models.append(VirtualObject(model: .sucos))
    models.append(VirtualObject(model: .weddingCake))
    models.append(VirtualObject(model: .senzaTitolo))
    
    return models
  }
  
  class func modelCategoryList() -> [Category] {
    return [.drinks, .cake, .noodlesSoup, .breakfast, .fastfood, .other]
  }
  
  func adjustPoisiton(position: SCNVector3) {
    
  }
  
  func reScaleModel(scale: SCNVector3) {
    
  }
  
  private class func getAllAvailableObjects(inFolder folderName: String, ofExtension fileExtension: String, andChildName name: String) -> [SCNNode] {
    let modelsURL = Bundle.main.url(forResource: folderName, withExtension: nil)!
    var models: [SCNNode] = []
    let fileEnumerator = FileManager().enumerator(at: modelsURL, includingPropertiesForKeys: [])!
    for filePath in fileEnumerator {
      guard let fileURL = filePath as? URL else { return [] }
      if fileURL.pathExtension == fileExtension {
        let modelScene = try? SCNScene(url: fileURL, options: nil)
        guard let scene = modelScene else { return [] }
        guard let modelNode = scene.rootNode.childNode(withName: name, recursively: false) else { return [] }
        models.append(modelNode)
      }
    }
    return models
  }
  
}

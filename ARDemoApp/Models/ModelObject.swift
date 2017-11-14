//
//  VirtualObject.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/9/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit

class ModelObject {
  
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
      price = "$ 1.9"
    case .birthdayCake:
      displayName = "Birthday Cake"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "BirthdayCake.jpg")
      price = "$ 4.9"
    case .breakfast:
      displayName = "Breakfast"
      category = .breakfast
      icon = ""
      image = #imageLiteral(resourceName: "BreakFast.jpg")
      price = "$ 2.9"
    case .blackforest:
      displayName = "Black Forest"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "BlackForestCake.jpg")
      price = "$ 0.9"
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
      price = "$ 7.9"
    case .cakePiece:
      displayName = "Cake Piece"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "CakePiece.jpg")
      price = "$ 1.9"
    case .chineseNoodles:
      displayName = "Haka Noodles"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "InstantNoodles.jpg")
      price = "$ 7.9"
    case .chocolateCake:
      displayName = "Chocolate Cake"
      category = .cake
      icon = ""
      image = #imageLiteral(resourceName: "ChocolateCake.jpg")
      price = "$ 5.9"
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
      price = "$ 0.9"
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
      price = "$ 14.9"
    case .giapponese:
      displayName = "Giapponese"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Giapponese.jpg")
      price = "$ 3.9"
    case .instantNodoles:
      displayName = "Noodles"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Noodles.jpg")
      price = "$ 1.9"
    case .jackDaniels:
      displayName = "Jack Daniels"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "JackDaniels.jpg")
      price = "$ 19.9"
    case .oskarBluesBeer:
      displayName = "Oskar Blues Beer"
      category = .drinks
      icon = ""
      image = #imageLiteral(resourceName: "OskarBlues.jpg")
      price = "$ 14.9"
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
      price = "$ 2.9"
    case .senzaTitolo:
      displayName = "Senza Titolo"
      category = .fastfood
      icon = ""
      image = #imageLiteral(resourceName: "HotDog.jpg")
      price = "$ 4.9"
    case .soup:
      displayName = "Soup"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Soup.jpg")
      price = "$ 8.9"
    case .sucos:
      displayName = "Sucos"
      category = .noodlesSoup
      icon = ""
      image = #imageLiteral(resourceName: "Sucos.jpg")
      price = "$ 2.9"
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
  
  class func getAllModels() -> [ModelObject] {
    var models: [ModelObject] = []
    
    models.append(ModelObject(model: .aarquiteta))
    models.append(ModelObject(model: .bierfles))
    models.append(ModelObject(model: .birthdayCake))
    models.append(ModelObject(model: .blackforest))
    models.append(ModelObject(model: .breakfast))
    models.append(ModelObject(model: .burger))
    models.append(ModelObject(model: .burgerFries))
    models.append(ModelObject(model: .cakePiece))
    models.append(ModelObject(model: .chineseNoodles))
    models.append(ModelObject(model: .chocolateCake))
    models.append(ModelObject(model: .clicquot))
    models.append(ModelObject(model: .cocacola))
    models.append(ModelObject(model: .fastFood))
    models.append(ModelObject(model: .franksBeansDinner))
    models.append(ModelObject(model: .giapponese))
    models.append(ModelObject(model: .instantNodoles))
    models.append(ModelObject(model: .jackDaniels))
    models.append(ModelObject(model: .oskarBluesBeer))
    models.append(ModelObject(model: .pepperoniPizza))
    models.append(ModelObject(model: .potatoChips))
    models.append(ModelObject(model: .soup))
    models.append(ModelObject(model: .sucos))
    models.append(ModelObject(model: .weddingCake))
    models.append(ModelObject(model: .senzaTitolo))
    
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

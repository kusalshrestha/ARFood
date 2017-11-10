//
//  VirtualObject.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/9/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation
import SceneKit

enum Category {
  case drinks, cake, breakfast, noodlesSoup, fastfood, other
}

enum ArtificialModel {
  case aarquiteta, bierfles, birthdayCake, blackforest, breakfast, burger, burgerFries, cakePiece, chineseNoodles, chocolateCake, clicquot, cocacola, fastFood, franksBeansDinner, giapponese, instantNodoles, jackDaniels, oskarBluesBeer, pepperoniPizza, potatoChips, senzaTitolo, soup, sucos, weddingCake
}

class VirtualObject {
  
  private var category: Category!
  private var path: String!
  var model: ArtificialModel!
  var displayName: String!
  var modelNode: SCNNode!
  var icon: String!
  var image: String!
  
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
      path = "Food.scnassets/Aarquiteta"
      icon = ""
      image = ""
    case .bierfles:
      displayName = "Bierfles"
      category = .drinks
      path = "Food.scnassets/Bierfles"
      icon = ""
      image = ""
    case .birthdayCake:
      displayName = "Birthday Cake"
      category = .cake
      path = "Food.scnassets/BirthdayCake"
      icon = ""
      image = ""
    case .breakfast:
      displayName = "Breakfast"
      category = .breakfast
      path = "Food.scnassets/Breakfast"
      icon = ""
      image = ""
    case .blackforest:
      displayName = "Black Forest"
      category = .cake
      path = "Food.scnassets/BlackForestCake"
      icon = ""
      image = ""
    case .burger:
      displayName = "Burger"
      category = .fastfood
      path = "Food.scnassets/Burger"
      icon = ""
      image = ""
    case .burgerFries:
      displayName = "Burger & Fries"
      category = .fastfood
      path = "Food.scnassets/BurgerFries"
      icon = ""
      image = ""
    case .cakePiece:
      displayName = "Cake Piece"
      category = .cake
      path = "Food.scnassets/CakePiece"
      icon = ""
      image = ""
    case .chineseNoodles:
      displayName = "Haka Noodles"
      category = .noodlesSoup
      path = "Food.scnassets/ChineseInstantNoodles"
      icon = ""
      image = ""
    case .chocolateCake:
      displayName = "Chocolate Cake"
      category = .cake
      path = "Food.scnassets/ChocolateCake"
      icon = ""
      image = ""
    case .clicquot:
      displayName = "Clicquot"
      category = .drinks
      path = "Food.scnassets/Clicquot"
      icon = ""
      image = ""
    case .cocacola:
      displayName = "Cocacola"
      category = .drinks
      path = "Food.scnassets/Cocacola"
      icon = ""
      image = ""
    case .fastFood:
      displayName = "Fast Food"
      category = .fastfood
      path = "Food.scnassets/FastFood"
      icon = ""
      image = ""
    case .franksBeansDinner:
      displayName = "Franks Beans Dinner"
      category = .other
      path = "Food.scnassets/FranksBeansDinner"
      icon = ""
      image = ""
    case .giapponese:
      displayName = "Giapponese"
      category = .noodlesSoup
      path = "Food.scnassets/Giapponese"
      icon = ""
      image = ""
    case .instantNodoles:
      displayName = "Noodles"
      category = .noodlesSoup
      path = "Food.scnassets/InstantNoodles"
      icon = ""
      image = ""
    case .jackDaniels:
      displayName = "Jack Daniels"
      category = .drinks
      path = "Food.scnassets/JackDaniels"
      icon = ""
      image = ""
    case .oskarBluesBeer:
      displayName = "Oskar Blues Beer"
      category = .drinks
      path = "Food.scnassets/OskarBluesBeerCan"
      icon = ""
      image = ""
    case .pepperoniPizza:
      displayName = "Pepperoni Pizza"
      category = .fastfood
      path = "Food.scnassets/PepperoniPizza"
      icon = ""
      image = ""
    case .potatoChips:
      displayName = "Potato Chips"
      category = .fastfood
      path = "Food.scnassets/PotatoChips"
      icon = ""
      image = ""
    case .senzaTitolo:
      displayName = "Senza Titolo"
      category = .fastfood
      path = "Food.scnassets/SenzaTitolo"
      icon = ""
      image = ""
    case .soup:
      displayName = "Soup"
      category = .noodlesSoup
      path = "Food.scnassets/Soup"
      icon = ""
      image = ""
    case .sucos:
      displayName = "Sucos"
      category = .noodlesSoup
      path = "Food.scnassets/Sucos"
      icon = ""
      image = ""
    case .weddingCake:
      displayName = "Wedding Cake"
      category = .cake
      path = "Food.scnassets/WeddingCake"
      icon = ""
      image = ""
    case .none:
      break
    case .some(_):
      break
    }
  }
  
  func getModel() -> SCNNode {
//    guard let url = URL(string: path + "/model.dae") else { return SCNNode() }
    let modelScene = SCNScene(named: path + "/model.dae")
    guard let scene = modelScene else { return SCNNode() }
    guard let modelNode = scene.rootNode.childNode(withName: "SketchUp", recursively: false) else { return SCNNode() }
    self.modelNode = modelNode
    return modelNode
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

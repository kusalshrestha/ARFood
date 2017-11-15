//
//  MainModel.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/11/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import Foundation

enum Category {
  case drinks, cake, breakfast, noodlesSoup, fastfood, other
  
  func getTitle() -> String {
    switch self {
    case .drinks:
      return "Featured Drinks"
    case .cake:
      return "Cakes"
    case .breakfast:
      return "Breakfast"
    case .noodlesSoup:
      return "Noodles & Soups"
    case .fastfood:
      return "Fastfood"
    case .other:
      return "Others"
    }
  }
}

enum ArtificialModel {
  
  case aarquiteta, bierfles, birthdayCake, blackforest, breakfast, burger, burgerFries, cakePiece, chineseNoodles, chocolateCake, clicquot, cocacola, fastFood, franksBeansDinner, giapponese, instantNodoles, jackDaniels, oskarBluesBeer, pepperoniPizza, potatoChips, senzaTitolo, soup, sucos, weddingCake
  
  func modelsPath() -> String {
    switch self {
    case .aarquiteta:
      return "Food.scnassets/Aarquiteta"
    case .bierfles:
      return "Food.scnassets/Bierfles"
    case .birthdayCake:
      return "Food.scnassets/BirthdayCake"
    case .breakfast:
      return "Food.scnassets/Breakfast"
    case .blackforest:
      return "Food.scnassets/BlackForestCake"
    case .burger:
      return "Food.scnassets/Burger"
    case .burgerFries:
      return "Food.scnassets/BurgerFries"
    case .cakePiece:
      return "Food.scnassets/CakePiece"
    case .chineseNoodles:
      return "Food.scnassets/ChineseInstantNoodles"
    case .chocolateCake:
      return "Food.scnassets/ChocolateCake"
    case .clicquot:
      return "Food.scnassets/Clicquot"
    case .cocacola:
      return "Food.scnassets/Cocacola"
    case .fastFood:
      return "Food.scnassets/FastFood"
    case .franksBeansDinner:
      return "Food.scnassets/FranksBeansDinner"
    case .giapponese:
      return "Food.scnassets/Giapponese"
    case .instantNodoles:
      return "Food.scnassets/InstantNoodles"
    case .jackDaniels:
      return "Food.scnassets/JackDaniels"
    case .oskarBluesBeer:
      return "Food.scnassets/OskarBluesBeerCan"
    case .pepperoniPizza:
      return "Food.scnassets/PepperoniPizza"
    case .potatoChips:
      return "Food.scnassets/PotatoChips"
    case .senzaTitolo:
      return "Food.scnassets/SenzaTitolo"
    case .soup:
      return "Food.scnassets/Soup"
    case .sucos:
      return "Food.scnassets/Sucos"
    case .weddingCake:
      return "Food.scnassets/WeddingCake"
    }
  }
  
  func modelURL() -> URL? {
    return Bundle.main.url(forResource: self.modelsPath() + "/model", withExtension: "dae")
  }
  
}


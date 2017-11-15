//
//  UIViewController+Extension.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/15/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

extension UIViewController {
  
  class func instantiate<T: UIViewController>(vc: T.Type) -> T {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
  }
  
}

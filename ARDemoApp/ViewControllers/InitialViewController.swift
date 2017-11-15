//
//  InitialViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/15/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class InitialViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    routeApplication()
  }
  
  private func routeApplication() {
    let window = UIApplication.shared.keyWindow
    var vc: UIViewController!
    if (FBSDKAccessToken.current() != nil) {
      vc = UIViewController.instantiate(vc: ViewController.self)
    } else {
      vc = UIViewController.instantiate(vc: LoginViewController.self)
    }
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
  }
  
}


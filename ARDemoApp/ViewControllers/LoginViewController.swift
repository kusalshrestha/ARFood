//
//  LoginViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/15/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fbLoginButton.delegate = self
    

    fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
  }
  
}

extension LoginViewController: FBSDKLoginButtonDelegate {
  
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if (result.token != nil) {
      fbLoginButton.isHidden = true
      let vc = UIViewController.instantiate(vc: ViewController.self)
      self.present(vc, animated: true) {
        UIApplication.shared.keyWindow?.rootViewController = vc
      }
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    
  }
  
}


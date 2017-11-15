//
//  ProfileViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/15/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
  
  var dismissCallBack: (() -> ())?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onTapTop(_ sender: UIButton) {
    dismissCallBack?()
  }
  
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
  
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    //
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    let window = UIApplication.shared.keyWindow
    let vc = UIViewController.instantiate(vc: LoginViewController.self)
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
  }
  
}

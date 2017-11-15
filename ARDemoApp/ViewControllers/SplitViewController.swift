//
//  SplitViewController.swift
//  ARDemoApp
//
//  Created by Shrstha Kusal on 11/15/17.
//  Copyright © 2017 Shrstha Kusal. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {
  
  @IBOutlet weak var superRoundedContainerView: UIView!
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  var isMenuVCShowing = true
  var dismissViewCallback: (() -> ())?
  var bottomConstantOriginalValue: CGFloat = 0
  
  let menuVC = UIViewController.instantiate(vc: MenuViewController.self)
  let profileVC = UIViewController.instantiate(vc: ProfileViewController.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    containerView.addSubview(profileVC.view)
    containerView.addSubview(menuVC.view)
    menuVC.profileButtonOnClick = showProfileVC
    initialState()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    heightConstraint.constant = UIScreen.main.bounds.height
    bottomConstantOriginalValue = bottomConstraint.constant
    view.layoutIfNeeded()
  }
  
  func initialState() {
    profileVC.view.isHidden = true
  }
  
  func showProfileVC() {
    isMenuVCShowing = !isMenuVCShowing // false
    animateContainer()
  }
  
  func showMenuVC() {
    isMenuVCShowing = !isMenuVCShowing //true
    animateContainer()
  }
  
  func animateContainer() {
    UIView.animate(withDuration: 0.45, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
      self.bottomConstraint.constant = UIScreen.main.bounds.height
      self.view.layoutIfNeeded()
    }) { (completed) in
      self.switchView()
      UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
        self.bottomConstraint.constant = self.bottomConstantOriginalValue
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func switchView() {
    profileVC.view.isHidden = isMenuVCShowing
    menuVC.view.isHidden = !isMenuVCShowing
  }
  
  @IBAction func onTapTop(_ sender: UIButton) {
    if isMenuVCShowing {
      dismissViewCallback?()
    } else {
      showProfileVC()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if isMenuVCShowing {
      menuVC.view.frame = containerView.bounds
    } else {
      profileVC.view.frame = containerView.bounds
    }
  }
  
}


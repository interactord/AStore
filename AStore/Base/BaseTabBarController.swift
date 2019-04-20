//
//  BaseTabBarController.swift
//  AStore
//
//  Created by SANGBONG MOON on 20/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
  
  /// 3 - maybe introduce our AppSearchController
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    viewControllers = [
      createNavController(viewController: AppSearchController(), title: "Search", imageName: "Search"),
      createNavController(viewController: UIViewController(), title: "Today", imageName: "Today"),
      createNavController(viewController: UIViewController(), title: "Apps", imageName: "Apps"),
    ]
    
  }
  
  private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
    let navController = UINavigationController(rootViewController: viewController)
    navController.navigationBar.prefersLargeTitles = true
    viewController.navigationItem.title = title
    navController.view.backgroundColor = .white
    navController.tabBarItem.title = title
    navController.tabBarItem.image = UIImage(named: imageName)
    return  navController
  }
}

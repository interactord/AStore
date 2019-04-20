//
//  BaseTabBarController.swift
//  AStore
//
//  Created by SANGBONG MOON on 20/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

  /// 1 - create Today controller
  /// 2 - refactor our repeated logic inside of viewDidLoad
  /// 3 - maybe introduce our AppSearchController
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    let todayController = UIViewController()
    todayController.view.backgroundColor = .white
    todayController.navigationItem.title = "Today"
  
    let todayNavController = UINavigationController(rootViewController: todayController)
    todayNavController.tabBarItem.title = "Today"
    todayNavController.tabBarItem.image = #imageLiteral(resourceName: "Today")
    todayNavController.navigationBar.prefersLargeTitles = true
    
    let redViewController = UIViewController()
    redViewController.view.backgroundColor = .red
    redViewController.navigationItem.title = "Apps"

    let redNavController = UINavigationController(rootViewController: redViewController)
    redNavController.tabBarItem.title = "Apps"
    redNavController.tabBarItem.image = #imageLiteral(resourceName: "Apps")
    redNavController.navigationBar.prefersLargeTitles = true

    let blueViewController = UIViewController()
    blueViewController.view.backgroundColor = .blue
    blueViewController.navigationItem.title = "Search"

    let blueNavController = UINavigationController(rootViewController: blueViewController)
    blueNavController.tabBarItem.title = "Search"
    blueNavController.tabBarItem.image = #imageLiteral(resourceName: "Search")
    blueNavController.navigationBar.prefersLargeTitles = true
    
    viewControllers = [
      todayNavController,
      redNavController,
      blueNavController
    ]

  }
}

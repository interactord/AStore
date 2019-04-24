//
//  BackEnabledNavigationController.swift
//  AStore
//
//  Created by SANGBONG MOON on 24/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController {

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.interactivePopGestureRecognizer?.delegate = self
  }
}

extension BackEnabledNavigationController: UIGestureRecognizerDelegate {

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.viewControllers.count > 1
  }

}

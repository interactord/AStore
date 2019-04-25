//
//  NavigationImageConstraint.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

struct ImageConstant {
  /// Image height/width for Large NavBar state
  static let imageSizeForLargeState: CGFloat = 40
  /// Margin from right anchor of safe area to right anchor of Image
  static let imageRightMargin: CGFloat = 16
  /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
  static let imageBottomMarginForLargeState: CGFloat = 12
  /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
  static let imageBottomMarginForSmallState: CGFloat = 10
  /// Image height/width for Small NavBar state
  static let imageSizeForSmallState: CGFloat = 32
  /// Height of NavBar for Small state. Usually it's just 44
  static let navBarHeightSmallState: CGFloat = 44
  /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
  static let navBarHeightLargeState: CGFloat = 96.5
}

//
//  MathTranslation.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

struct MathTranslation {
  /// coefficients
  struct Transform {
    let scale: CGFloat
    let translationX: CGFloat
    let translationY: CGFloat
  }

  func getScaleAndPosition(for height: CGFloat) -> Transform {

    /// coefficients
    let coeff: CGFloat = {
      let delta = height - ImageConstant.navBarHeightSmallState
      let heightDifferenceBetweenStates = (
        ImageConstant.navBarHeightLargeState - ImageConstant.navBarHeightSmallState
      )
      return delta / heightDifferenceBetweenStates
    }()

    let factor = ImageConstant.imageSizeForSmallState / ImageConstant.imageSizeForLargeState

    let scale: CGFloat = {
      let sizeAddendumFactor = coeff * (1.0 - factor)
      return min(1.0, sizeAddendumFactor + factor)
    }()

    // Value of difference between icons for large and small states
    let sizeDiff = ImageConstant.imageSizeForLargeState * (1.0 - factor) // 8.0

    let translationY: CGFloat = {
      /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
      let translationMaxY = ImageConstant.imageBottomMarginForLargeState - ImageConstant.imageBottomMarginForSmallState + sizeDiff
      return max(0, min(translationMaxY, (translationMaxY - coeff * (ImageConstant.imageBottomMarginForSmallState + sizeDiff))))
    }()

    let translationX = max(0, sizeDiff - coeff * sizeDiff)

    return .init(
      scale: scale,
      translationX: translationX,
      translationY: translationY
    )
  }

}

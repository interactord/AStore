//
//  UIStackView+Extenison.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

extension UIStackView {

  convenience init(arrangedSubViews: [UIView], customSpacing: CGFloat = 0) {
    self.init(arrangedSubviews: arrangedSubViews)
    self.spacing = customSpacing
  }
}

//
//  UILabel+Extension.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

extension UILabel {
  convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
    self.numberOfLines = numberOfLines
  }
}

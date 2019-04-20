//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
  init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
    super.init(frame: .zero)

    arrangedSubviews.forEach { addArrangedSubview($0) }
    self.spacing = spacing
    axis = .vertical
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

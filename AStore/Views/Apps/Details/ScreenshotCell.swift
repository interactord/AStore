//
//  ScreenshotCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {

  let imageView = UIImageView(cornerRadius: 12)

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)
    imageView.backgroundColor = .red
    imageView.fillSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

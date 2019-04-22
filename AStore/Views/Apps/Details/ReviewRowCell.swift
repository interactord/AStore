//
//  ReviewRowCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {

  let reviewsController = ReviewsController()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .yellow

    addSubview(reviewsController.view)
    reviewsController.view.fillSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

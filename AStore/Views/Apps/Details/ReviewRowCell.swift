//
//  ReviewRowCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {

  let reviewRatingsLabel = UILabel(text: "Reviews & Ratings", font: .boldSystemFont(ofSize: 20))
  let reviewsController = ReviewsController()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(reviewRatingsLabel)
    addSubview(reviewsController.view)
    reviewRatingsLabel.anchor(
      top: topAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 20, left: 20, bottom: 0, right: 20)
    )

    reviewsController.view.anchor(
      top: reviewRatingsLabel.bottomAnchor,
      leading: leadingAnchor,
      bottom: bottomAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 20, left: 0, bottom: 0, right: 0)
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

//
//  AppsGroupCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {

  let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))

  let horizontalController = AppsHorizontalController()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .lightGray

    addSubview(titleLabel)

    titleLabel.anchor(
      top: topAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor
    )

    addSubview(horizontalController.view)

    horizontalController.view.anchor(
      top: titleLabel.bottomAnchor,
      leading: leadingAnchor,
      bottom: bottomAnchor,
      trailing: trailingAnchor
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

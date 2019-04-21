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
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

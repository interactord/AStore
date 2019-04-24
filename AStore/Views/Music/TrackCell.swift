//
//  File.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {

  let imageView = UIImageView(cornerRadius: 16)
  let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
  let subTitleLabel = UILabel(text: "subTitle Label", font: .systemFont(ofSize: 16), numberOfLines: 2)

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.image = #imageLiteral(resourceName: "Garden")
    imageView.constrainWidth(constant: 80)

    let stackView = UIStackView(arrangedSubViews: [
      imageView,
      VerticalStackView(arrangedSubviews: [
        nameLabel,
        subTitleLabel
      ], spacing: 4)
    ], customSpacing: 16)

    addSubview(stackView)

    stackView.fillSuperview(
      padding: .init(top: 16, left: 16, bottom: 16, right: 16)
    )
    stackView.alignment = .center

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

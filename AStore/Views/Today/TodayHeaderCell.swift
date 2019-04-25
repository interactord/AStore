//
//  TodayHeader.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayHeaderCell: UICollectionViewCell {

  let dateLabel = UILabel(text: "THURSDAY, APRIL 5", font: .systemFont(ofSize: 14))
  private let todayLabel = UILabel(text: "Today", font: .boldSystemFont(ofSize: 34))
  private let avatarImageView = UIImageView(cornerRadius: 42 / 2)

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    dateLabel.textColor = #colorLiteral(red: 0.4780890942, green: 0.4780890942, blue: 0.4780890942, alpha: 1)

    avatarImageView.constrainWidth(constant: 42)
    avatarImageView.constrainHeight(constant: 42)
    avatarImageView.image = #imageLiteral(resourceName: "Avatar")

    let stackVIew = UIStackView(arrangedSubViews: [
      VerticalStackView(arrangedSubviews: [
        dateLabel,
        todayLabel
      ], spacing: 6),
      avatarImageView
    ])

    stackVIew.alignment = .center

    addSubview(stackVIew)
    stackVIew.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: bottomAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 32, bottom: 0, right: 32)
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

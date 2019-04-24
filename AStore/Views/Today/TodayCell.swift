//
//  TodayCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {

  private let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
  private let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28))
  private let imageView = UIImageView(image: #imageLiteral(resourceName: "Garden"))
  private lazy var descriptionLabel = UILabel(text: dummyDescription(), font: .systemFont(ofSize: 16), numberOfLines: 3)

  override var todayItem: TodayItem! {
    didSet {
      categoryLabel.text = todayItem.category
      titleLabel.text = todayItem.title
      imageView.image = todayItem.image
      descriptionLabel.text = todayItem.description
      backgroundColor = todayItem.backgroundColor
    }
  }

  var topConstaint: NSLayoutConstraint!

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    clipsToBounds = true
    layer.cornerRadius = 16
    imageView.contentMode = .scaleAspectFill

    let imageContainerView = UIView()
    imageContainerView.addSubview(imageView)
    imageView.centerInSuperview(
      size: .init(width: 240, height: 240)
    )

    let stackView = VerticalStackView(arrangedSubviews: [
      categoryLabel,
      titleLabel,
      imageContainerView,
      descriptionLabel
    ], spacing: 8)

    addSubview(stackView)

    stackView.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: bottomAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 24, bottom: 24, right: 24)
    )

    topConstaint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
    topConstaint.isActive = true

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func dummyDescription() -> String {
    return "All the tools and apps your need to intelligently organize your life the right way."
  }

}

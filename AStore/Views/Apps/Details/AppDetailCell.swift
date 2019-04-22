//
//  AppDetailCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit
import SDWebImage

class AppDetailCell: UICollectionViewCell {

  var app: SearchResultResponse! {
    didSet {
      nameLabel.text = app?.trackName
      releaseNotLabel.text = app?.releaseNotes
      appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
      priceButton.setTitle(app?.formattedPrice, for: .normal)
    }
  }
  let appIconImageView = UIImageView(cornerRadius: 16)
  let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 20), numberOfLines: 2)
  let priceButton = UIButton(title: "$4.99")
  let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
  let releaseNotLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .lightGray

    appIconImageView.backgroundColor = .red
    appIconImageView.constrainWidth(constant: 140)
    appIconImageView.constrainHeight(constant: 140)

    priceButton.backgroundColor = #colorLiteral(red: 0.09134501964, green: 0.3868643641, blue: 0.965174973, alpha: 1)
    priceButton.constrainHeight(constant: 32)
    priceButton.constrainWidth(constant: 80)
    priceButton.layer.cornerRadius = 32 / 2
    priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    priceButton.setTitleColor(.white, for: .normal)

    let stackView = VerticalStackView(arrangedSubviews: [
      UIStackView(arrangedSubViews: [
        appIconImageView,
        VerticalStackView(arrangedSubviews: [
          nameLabel,
          UIStackView(arrangedSubViews: [
            priceButton,
            UIView()
          ]),
          UIView()
        ], spacing: 12)
      ], customSpacing: 20),
      whatsNewLabel,
      releaseNotLabel
    ], spacing: 16)
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

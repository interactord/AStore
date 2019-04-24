//
//  MusicLoadingFooter.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicatorView.color = .darkGray
    activityIndicatorView.startAnimating()

    let loadingLabel = UILabel(text: "Loading more...", font: .systemFont(ofSize: 16))
    loadingLabel.textAlignment = .center

    let stackView = VerticalStackView(arrangedSubviews: [
      activityIndicatorView,
      loadingLabel
    ], spacing: 8)

    addSubview(stackView)
    stackView.centerInSuperview(
      size: .init(width: 200, height: 0)
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

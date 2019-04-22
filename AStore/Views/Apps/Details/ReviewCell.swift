//
//  ReviewCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

  let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
  let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
  let starsLabel = UILabel(text: "Starts", font: .systemFont(ofSize: 14))
  let bodyLabel = UILabel(text: "Review body\nReview body\nReview body", font: .systemFont(ofSize: 14), numberOfLines: 0)

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    layer.cornerRadius = 16
    clipsToBounds = true

    let stackView = VerticalStackView(arrangedSubviews: [
      UIStackView(arrangedSubViews: [
        titleLabel,
        UIView(),
        authorLabel
      ]),
      starsLabel,
      bodyLabel
    ], spacing: 12)

    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

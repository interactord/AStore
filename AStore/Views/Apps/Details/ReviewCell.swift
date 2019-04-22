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
  let bodyLabel = UILabel(text: "Review body\nReview body\nReview body", font: .systemFont(ofSize: 18), numberOfLines: 5)
  let startsStackView: UIStackView = {
    var arrangedSubViews = [UIView]()
    (0..<5).forEach { _ in
      let imageView = UIImageView(image: #imageLiteral(resourceName: "Star-Active"))
      imageView.constrainWidth(constant: 18)
      imageView.constrainHeight(constant: 18)
      arrangedSubViews.append(imageView)
    }
    arrangedSubViews.append(UIView())
    let stackView = UIStackView(arrangedSubViews: arrangedSubViews)
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    layer.cornerRadius = 16
    clipsToBounds = true

    let stackView = VerticalStackView(arrangedSubviews: [
      UIStackView(arrangedSubViews: [
        titleLabel,
        authorLabel
      ], customSpacing: 8),
      startsStackView,
      bodyLabel
    ], spacing: 12)

    titleLabel.setContentHuggingPriority(.init(0), for: .horizontal)
    authorLabel.textAlignment = .right
    addSubview(stackView)
    stackView.anchor(
      top: topAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 20, left: 20, bottom: 0, right: 20)
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

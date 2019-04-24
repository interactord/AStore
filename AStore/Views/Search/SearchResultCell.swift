//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {

  var appResult: SearchResultResponse! {
    didSet {
      nameLabel.text = appResult.trackName
      categoryLabel.text = appResult.primaryGenreName
      ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"

      let url = URL(string: appResult.artworkUrl100)
      appIconImageView.sd_setImage(with: url)

      screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls?[0] ?? ""))
      if appResult.screenshotUrls?.count ?? 0 > 1 {
        screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls?[1] ?? ""))
      }
      if appResult.screenshotUrls?.count ?? 0 > 2 {
        screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls?[2] ?? ""))
      }
    }
  }

  let appIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    return imageView
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "APP NAME"
    return label
  }()

  let categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "Photo & Video"
    return label
  }()

  let ratingsLabel: UILabel = {
    let label = UILabel()
    label.text = "611K"
    return label
  }()

  let getButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitleColor(.blue, for: .normal)
    button.setTitle("GET", for: .normal)
    button.backgroundColor = .init(white: 0.95, alpha: 1)
    button.titleLabel?.font = .boldSystemFont(ofSize: 14)
    button.widthAnchor.constraint(equalToConstant: 80).isActive = true
    button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    button.layer.cornerRadius = 16
    return button
  }()

  lazy var screenshot1ImageView = self.createScreenShotImageView()
  lazy var screenshot2ImageView = self.createScreenShotImageView()
  lazy var screenshot3ImageView = self.createScreenShotImageView()

  func createScreenShotImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 0.6
    imageView.layer.borderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    // optional

    let infoTopStackView = UIStackView(arrangedSubviews: [
      appIconImageView,
      VerticalStackView(arrangedSubviews: [
        nameLabel,
        categoryLabel,
        ratingsLabel
      ]),
      getButton
    ])

    infoTopStackView.spacing = 12
    infoTopStackView.alignment = .center

    let screenshotsStackView = UIStackView(arrangedSubviews: [
      screenshot1ImageView,
      screenshot2ImageView,
      screenshot3ImageView
    ])
    screenshotsStackView.spacing = 12
    screenshotsStackView.distribution = .fillEqually

    let overallStackView = VerticalStackView(
      arrangedSubviews: [
        infoTopStackView,
        screenshotsStackView
      ],
      spacing: 16
    )

    addSubview(overallStackView)
    overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

//
//  ReviewsController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class ReviewsController: HorizontalSnappingController {

  private let cellId = "cellId"
  private let cellSpacing: CGFloat = 40
  private let padding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)

  var reviews: Reviews? {
    didSet {
      self.collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.contentInset = padding
    collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return reviews?.feed.entry.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

    guard
      let reviewCell = cell as? ReviewCell,
      let entry = reviews?.feed.entry[indexPath.item]
      else {
        return cell
    }

    reviewCell.authorLabel.text = entry.author.name.label
    reviewCell.titleLabel.text = entry.title.label
    reviewCell.bodyLabel.text = entry.content.label

    for (index, view) in reviewCell.startsStackView.arrangedSubviews.enumerated() {
      if let ratingInt = Int(entry.rating.label) {
        view.alpha = index >= ratingInt ? 0 : 1
      }
    }

    return reviewCell
  }

}

extension ReviewsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - cellSpacing, height: view.frame.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
}

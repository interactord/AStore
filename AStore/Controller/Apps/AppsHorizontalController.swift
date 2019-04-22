//
//  AppHorizontalController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

import SDWebImage

class AppsHorizontalController: HorizontalSnappingController {

  private let cellId = "cellId"
  private let topBottomPadding: CGFloat = 12
  private let lineSpacing: CGFloat = 10
  var appGroup: AppGroup?

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appGroup?.feed.results.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

    guard
      let appRowCell = cell as? AppRowCell,
      let app = appGroup?.feed.results[indexPath.item]
      else {
        return cell
    }

    appRowCell.nameLabel.text = app.name
    appRowCell.companyLabel.text = app.artistName
    appRowCell.imageView.sd_setImage(with: URL(string: app.artworkUrl100))

    return appRowCell
  }

}

extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
    return .init(width: view.frame.width - 48, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
  }
}

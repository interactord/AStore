//
//  AppHeaderHorizontalController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit
import SDWebImage

class AppsHeaderHorizontalController: HorizontalSnappingController {

  private let cellId = "cellId"
  var socialApps = [SocialApp]()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return socialApps.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let headerCell = cell as? AppsHeaderCell else {
      return cell
    }

    let app = self.socialApps[indexPath.item]
    headerCell.companyLabel.text = app.name
    headerCell.titleLabel.text = app.tagline
    headerCell.imageView.sd_setImage(with: URL(string: app.imageUrl))
    return headerCell
  }

}

extension AppsHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 48, height: view.frame.height)
  }
}

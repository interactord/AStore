//
//  PreviewScreenshotsController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class PreviewScreenshotsController: HorizontalSnappingController {

  private let cellId = "cellId"
  private let padding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)

  var app: SearchResultResponse? {
    didSet {
      collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.contentInset = padding
    collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return app?.screenshotUrls.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let screenShotCell = cell as? ScreenshotCell else {
      return cell
    }
    let screenshotUrl = app?.screenshotUrls[indexPath.item]
    screenShotCell.imageView.sd_setImage(with: URL(string: screenshotUrl ?? ""))
    return screenShotCell
  }
}

extension PreviewScreenshotsController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 250, height: view.frame.height)
  }
}

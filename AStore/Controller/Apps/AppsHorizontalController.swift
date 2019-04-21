//
//  AppHorizontalController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppsHorizontalController: BaseListController {

  private let cellId = "cellId"
  private let topBottomPadding: CGFloat = 12
  private let lineSpacing: CGFloat = 10

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .blue

    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)

    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }

}

extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
    return .init(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 12, left: 16, bottom: 12, right: 16)
  }
}

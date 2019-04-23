//
//  TodayMultipleController.swift
//  AStore
//
//  Created by SANGBONG MOON on 24/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayMultipleController: BaseListController {

  private let cellId = "cellId"

  private let spacing: CGFloat = 12

  private var results = [FeedResult]()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.isScrollEnabled = false

    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)

    Service.shared.fetchGames { appGroup, _ in
      self.results = appGroup?.feed.results ?? []

      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return min(4, results.count)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let mutipleAppCell = cell as? MultipleAppCell else {
      return cell
    }
    mutipleAppCell.app = results[indexPath.item]
    return mutipleAppCell
  }
}

extension TodayMultipleController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let height: CGFloat = (view.frame.height - 3 * spacing) / 4
    return .init(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
}

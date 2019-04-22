//
//  AppsController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {

  private let cellId = "cellId"
  private let headerId = "headerId"

  private var editorsChoicesGames: AppGroup?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

    fetchData()
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    return header
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let appsGroupCell = cell as? AppsGroupCell else {
      return cell
    }
    appsGroupCell.titleLabel.text = editorsChoicesGames?.feed.title
    appsGroupCell.horizontalController.appGroup = editorsChoicesGames
    appsGroupCell.horizontalController.collectionView.reloadData()AStore/Controller/Apps/AppsHorizontalController.swift
    return appsGroupCell
  }

  private func fetchData() {
    Service.shared.fetchGames { appGroup, err in
      if let err = err {
        print("Fail fetched app group", err)
      }
      self.editorsChoicesGames = appGroup
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

}

extension AppsPageController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 300)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 300)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 0, bottom: 0, right: 0)
  }
}

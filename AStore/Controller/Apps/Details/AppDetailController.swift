//
//  AppDetailController.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {

  private let detailCellId = "detailCellId"
  private var app: SearchResultResponse?
  var appId: String! {
    didSet {
      guard let appId = appId else {
        return
      }
      let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
      Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
        if let err = err {
          print("failed to app detail", err)
          return
        }
        let app = result?.results.first
        self.app = app
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)

    navigationItem.largeTitleDisplayMode = .never
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath)
    guard let detailCell = cell as? AppDetailCell else {
      return cell
    }
    detailCell.app = app

    return detailCell
  }
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    /// calculate the necessary size for our cell somehow
    let size = CGSize(width: view.frame.width, height: 1_000)
    let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
    dummyCell.app = app
    dummyCell.layoutIfNeeded()
    let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: size.height))

    return .init(width: view.frame.width, height: estimatedSize.height)
  }
}

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

        if let result = result {
          print(result.results.first?.releaseNotes ?? "")
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
    return cell
  }
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 300)
  }
}

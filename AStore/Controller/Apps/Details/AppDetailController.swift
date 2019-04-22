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
  private let previewCellId = "previewCellId"
  private let reviewCellId = "reviewCellId"

  private var app: SearchResultResponse?
  private var reviews: Reviews?

  private let appId: String

  /// dependency injection contructor
  init(appId: String) {
    self.appId = appId
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
    collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
    collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)

    navigationItem.largeTitleDisplayMode = .never
    fetchData()
  }

  private func fetchData() {
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

    let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"

    Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, err) in
      if let err = err {
        print("failed to decode reviews", err)
        return
      }

      self.reviews = reviews
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if indexPath.item == 0 {

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath)
      guard let detailCell = cell as? AppDetailCell else {
        return cell
      }
      detailCell.app = app

      return detailCell

    } else if indexPath.item == 1 {

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath)
      guard let previewCell = cell as? PreviewCell else {
        return cell
      }
      previewCell.horizontalController.app = app
      return previewCell

    } else {

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath)
      guard let reviewRowCell = cell as? ReviewRowCell else {
        return cell
      }
      reviewRowCell.reviewsController.reviews = reviews
      return reviewRowCell

    }
  }
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let fullWidth = view.frame.width
    var height: CGFloat = 280

    if indexPath.item == 0 {

      /// calculate the necessary size for our cell somehow
      let size = CGSize(width: view.frame.width, height: 1_000)
      let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
      dummyCell.app = app
      dummyCell.layoutIfNeeded()
      let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: size.height))
      height = estimatedSize.height

    } else if indexPath.item == 1 {
      height = 500
    } else {
      height = 280
    }

    return .init(width: fullWidth, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 10, right: 0)
  }
}

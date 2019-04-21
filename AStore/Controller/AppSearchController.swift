//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit
import SDWebImage

class AppSearchController: UICollectionViewController {

  private let cellId = "cellID"
  private var appResults = [SearchResultResponse]()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)

    fetchITunesApps()
  }

  private func fetchITunesApps() {

    Service.shared.fetchApps { result, err in
      if let err = err {
        print("Failed to fetch apps:", err)
        return
      }

      self.appResults = result
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }

    }
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

    guard let searchResultCell = cell as? SearchResultCell else {
      return cell
    }
    searchResultCell.appResult = appResults[indexPath.item]
    return searchResultCell
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appResults.count
  }

  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension AppSearchController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width
    return .init(width: width, height: 350)
  }
}

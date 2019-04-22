//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit
import SDWebImage

class AppSearchController: BaseListController {

  private let cellId = "cellID"
  private let searchController = UISearchController(searchResultsController: nil)
  private let enterSearchTermLabel: UILabel = {
    let label = UILabel()
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    label.font = .boldSystemFont(ofSize: 20)
    return label
  }()

  private var appResults = [SearchResultResponse]()
  var timer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)

    collectionView.addSubview(enterSearchTermLabel)
    enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))

    setupSearchbar()
  }

  private func setupSearchbar() {
    definesPresentationContext = true
    navigationItem.searchController = self.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
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
    enterSearchTermLabel.isHidden = !appResults.isEmpty
    return appResults.count
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let appId = appResults[indexPath.item].trackId
    let appDetailController = AppDetailController(appId: "\(appId)")
    navigationController?.pushViewController(appDetailController, animated: true)
  }
}

extension AppSearchController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width
    return .init(width: width, height: 350)
  }
}

extension AppSearchController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)

    /// interoduce some delay before performing the search
    // throttling the search

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in

      /// this will actually fire my search
      Service.shared.fetchApps(searchTerm: searchText) { res, err in

        if let err = err {
          print("Failed to apps:", err)
          return
        }

        self.appResults = res?.results ?? []
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    })
  }
}

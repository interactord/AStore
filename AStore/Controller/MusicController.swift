//
//  MusicController.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class MusicController: BaseListController {

  private let cellId = "cellId"
  private let footerId = "footerId"
  private let searchController = UISearchController(searchResultsController: nil)
  private var timer: Timer?
  private let noSearchView = NoSearchView()
  var searchTerm: String?
  private var isPaginating = false
  var isDonePagination = false

  var results = [SearchResultResponse]()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSearchBar()

    view.addSubview(noSearchView)
    noSearchView.fillSuperview()

    collectionView.isHidden = true
    collectionView.backgroundColor = .white
    collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(
      MusicLoadingFooter.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: footerId
    )
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collectionView.isHidden = results.isEmpty
    noSearchView.isHidden = !results.isEmpty

    print(results.count)
    return results.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let trackCell = cell as? TrackCell else {
      return cell
    }

    let track = results[indexPath.item]
    trackCell.nameLabel.text = track.trackName
    trackCell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
    trackCell.subTitleLabel.text = "\(track.artistName ?? "") ∙ \(track.collectionName ?? "")"

    /// initiate pagiantion
    if indexPath.item == results.count - 1 {
      fetchData()
    }

    return trackCell
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    guard let footerView = view as? MusicLoadingFooter else {
      return view
    }

    return footerView
  }

}

extension MusicController {

  private func setupSearchBar() {
    definesPresentationContext = true
    navigationItem.searchController = self.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }

  private func removeAllData() {
    results.removeAll()
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }

  private func fetchData(isRefrashed: Bool = false) {

    guard
      let searchTerm = searchTerm, !searchTerm.isEmpty
      else {
        removeAllData()
        return
    }

    if isRefrashed {
      isPaginating = false
    }

    if isPaginating { return }
    isPaginating = true
    noSearchView.activityIndicatorView.startAnimating()
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=25"
    Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
      if let err = err {
        print("Failed to paginate data: ", err)
        return
      }

      guard let result = searchResult?.results else {
        return
      }

      if searchResult?.results.isEmpty ?? true {
        self.isDonePagination = true
      }

      sleep(2)

      self.results += result

      DispatchQueue.main.async {
        self.collectionView.reloadData()
        self.noSearchView.activityIndicatorView.stopAnimating()
      }
      self.isPaginating = false
    }
  }
}

extension MusicController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let height: CGFloat = isDonePagination ? 0 : 100
    return .init(width: view.frame.width, height: height)
  }
}

extension MusicController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    /// interoduce some delay before performing the search
    // throttling the search

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
      print(searchText)
      self.searchTerm = searchText
      self.isPaginating = false
      self.removeAllData()
      self.fetchData(isRefrashed: true)
    }
  }
}

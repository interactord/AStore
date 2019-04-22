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

  let activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.color = .black
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()

  private var editorsChoicesGames: AppGroup?
  private var groups = [AppGroup]()
  private var socialApps = [SocialApp]()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

    view.addSubview(activityIndicatorView)
    activityIndicatorView.fillSuperview()

    fetchData()
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    guard let header = view as? AppsPageHeader else {
      return view
    }
    header.appsHeaderHorizontalController.socialApps = self.socialApps
    header.appsHeaderHorizontalController.collectionView.reloadData()
    return header
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return groups.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let appsGroupCell = cell as? AppsGroupCell else {
      return cell
    }
    let appGroup = groups[indexPath.item]
    appsGroupCell.titleLabel.text = appGroup.feed.title
    appsGroupCell.horizontalController.appGroup = appGroup
    appsGroupCell.horizontalController.collectionView.reloadData()
    return appsGroupCell
  }

  private func fetchData() {

    var group1: AppGroup?
    var group2: AppGroup?
    var group3: AppGroup?

    /// help you async your data fetches together
    let dispathGroup = DispatchGroup()

    dispathGroup.enter()
    Service.shared.fetchGames { appGroup, err in
      dispathGroup.leave()
      if let err = err {
        print("Fail fetched app group", err)
        return
      }
      group1 = appGroup
    }

    dispathGroup.enter()
    Service.shared.fetchTopGrossing { appGroup, err in
      dispathGroup.leave()
      if let err = err {
        print("Fail fetched app group", err)
        return
      }
      group2 = appGroup
    }

    dispathGroup.enter()
    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { appGroup, err in
      dispathGroup.leave()
      if let err = err {
        print("Fail fetched app group", err)
        return
      }
      group3 = appGroup
    }

    dispathGroup.enter()
    Service.shared.fetchSocialApps { apps, err in
      dispathGroup.leave()
      if let err = err {
        print("Fail fetched social app", err)
        return
      }
      self.socialApps = apps ?? []
    }

    /// completion
    dispathGroup.notify(queue: .main) {
      print("completed your dispatch group task...")
      self.activityIndicatorView.stopAnimating()
      if let group = group1 {
        self.groups.append(group)
      }

      if let group = group2 {
        self.groups.append(group)
      }

      if let group = group3 {
        self.groups.append(group)
      }

      self.collectionView.reloadData()
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

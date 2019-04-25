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

  let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))

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

    setUpNavigationUI()

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
    appsGroupCell.horizontalController.didSelectHandler = { [weak self] feedResult in
      let controller = AppDetailController(appId: feedResult.id)
      controller.navigationItem.title = feedResult.name
      self?.navigationController?.pushViewController(controller, animated: true)
    }

    return appsGroupCell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let redController = UIViewController()
    redController.view.backgroundColor = .red
    navigationController?.pushViewController(redController, animated: true)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let height = navigationController?.navigationBar.frame.height else {
      return
    }
    let transform = MathTranslation().getScaleAndPosition(for: height)
    avatarImageView.transform = CGAffineTransform.identity
      .scaledBy(x: transform.scale, y: transform.scale)
      .translatedBy(x: transform.translationX, y: transform.translationY)
  }
}

private extension AppsPageController {

  private func setUpNavigationUI() {
    guard let navigatioBar = navigationController?.navigationBar else {
      return
    }
    navigatioBar.addSubview(avatarImageView)
    avatarImageView.layer.cornerRadius = ImageConstant.imageSizeForLargeState / 2
    avatarImageView.clipsToBounds = true
    avatarImageView.anchor(
      top: nil,
      leading: nil,
      bottom: navigatioBar.bottomAnchor,
      trailing: navigatioBar.trailingAnchor,
      padding: .init(
        top: 0,
        left: 0,
        bottom: ImageConstant.imageBottomMarginForLargeState,
        right: ImageConstant.imageRightMargin
      ),
      size: .init(
        width: ImageConstant.imageSizeForLargeState,
        height: ImageConstant.imageSizeForLargeState
      )
    )
  }

  private func fetchData() {

    var group1: AppGroup?
    var group2: AppGroup?
    var group3: AppGroup?

    /// help you async your data fetches together
    let dispatchGroup = DispatchGroup()

    dispatchGroup.enter()
    Service.shared.fetchGames { appGroup, err in
      if let err = err {
        print("Fail fetched app group", err)
        dispatchGroup.leave()
        return
      }
      group1 = appGroup
      dispatchGroup.leave()
    }

    dispatchGroup.enter()
    Service.shared.fetchTopGrossing { appGroup, err in
      if let err = err {
        print("Fail fetched app group", err)
        dispatchGroup.leave()
        return
      }
      dispatchGroup.leave()
      group2 = appGroup
    }

    dispatchGroup.enter()
    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { appGroup, err in
      if let err = err {
        print("Fail fetched app group", err)
        dispatchGroup.leave()
        return
      }
      group3 = appGroup
      dispatchGroup.leave()
    }

    dispatchGroup.enter()
    Service.shared.fetchSocialApps { apps, err in
      if let err = err {
        print("Fail fetched social app", err)
        dispatchGroup.leave()
        return
      }
      self.socialApps = apps ?? []
      dispatchGroup.leave()
    }

    /// completion
    dispatchGroup.notify(queue: .main) {
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

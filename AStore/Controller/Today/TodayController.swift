//
//  TodayController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

  static let cellSize: CGFloat = 500

  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController!
  var items = [TodayItem]()
  var activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.color = .darkGray
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()

  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()

    fetchData()

    navigationController?.isNavigationBarHidden = true

    collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
    collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
  }

  private func fetchData() {
    // dispatchGroup

    let dispatchGroup = DispatchGroup()

    var topGrossingGroup: AppGroup?
    var gamesGroup: AppGroup?

    dispatchGroup.enter()
    Service.shared.fetchTopGrossing { appGroup, err in
      if let err = err {
        print("Fail fetched topGrossing app", err)
        dispatchGroup.leave()
        return
      }

      topGrossingGroup = appGroup
      dispatchGroup.leave()
    }

    dispatchGroup.enter()
    Service.shared.fetchGames { appGroup, err in
      if let err = err {
        print("Fail fetched games app", err)
        dispatchGroup.leave()
        return
      }

      gamesGroup = appGroup
      dispatchGroup.leave()
    }

    /// completion block
    dispatchGroup.notify(queue: .main) {
      self.activityIndicatorView.stopAnimating()

      self.items = [
        TodayItem(
          category: "Daily List",
          title: topGrossingGroup?.feed.title ?? "",
          image: #imageLiteral(resourceName: "Garden"),
          description: "",
          backgroundColor: .white,
          cellType: .multiple,
          apps: topGrossingGroup?.feed.results ?? []
        ),
        TodayItem(
          category: "Daily List",
          title: gamesGroup?.feed.title ?? "",
          image: #imageLiteral(resourceName: "Garden"),
          description: "",
          backgroundColor: .white,
          cellType: .multiple,
          apps: gamesGroup?.feed.results ?? []
        ),
        TodayItem(
          category: "LIFE HACK",
          title: "Utilizing your Time",
          image: #imageLiteral(resourceName: "Garden"),
          description: "All the tools and apps your need to intelligently organize your life the right way.",
          backgroundColor: .white,
          cellType: .single,
          apps: []
        )
      ]

      self.collectionView.reloadData()
    }

  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cellId = items[indexPath.item].cellType.rawValue

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

    if let cell = cell as? BaseTodayCell {
      cell.todayItem = items[indexPath.item]
    }

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    guard
      let cell = collectionView.cellForItem(at: indexPath),
      let startingFrame = cell.superview?.convert(cell.frame, to: nil) /// absolute coordinates of cell
      else {
        return
    }

    if items[indexPath.item].cellType == .multiple {
      let fullController = TodayMultipleAppsController(mode: .fullScreen)
      fullController.results = self.items[indexPath.item].apps
      present(fullController, animated: true)

      return
    }

    self.startingFrame = startingFrame

    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.item]
    appFullscreenController.dismissHandler = {
      self.removeFullscreenView()
    }
    guard let fullscreenView = appFullscreenController.view else {
      return
    }
    fullscreenView.frame = startingFrame
    fullscreenView.layer.cornerRadius = 16
    view.addSubview(fullscreenView)
    addChild(appFullscreenController)

    self.appFullscreenController = appFullscreenController
    self.collectionView.isUserInteractionEnabled = false

    /// autolayout constaint animation
    fullscreenView.translatesAutoresizingMaskIntoConstraints = false
    topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
    leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
    widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.size.width)
    heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.size.height)

    [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach {
      $0?.isActive = true
    }
    self.view.layoutIfNeeded()

    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        self.topConstraint?.constant = 0
        self.leadingConstraint?.constant = 0
        self.widthConstraint?.constant = self.view.frame.width
        self.heightConstraint?.constant = self.view.frame.height

        self.view.layoutIfNeeded()
        self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

        guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else {
          return
        }
        cell.todayCell.topConstaint.constant = 48
        cell.layoutIfNeeded()
      }
    )
  }

  func removeFullscreenView() {

    guard let statringFrame = self.startingFrame else {
      return
    }

    /// access startingFrame
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        self.appFullscreenController.tableView.contentOffset = .zero
        self.topConstraint?.constant = statringFrame.origin.y
        self.leadingConstraint?.constant = statringFrame.origin.x
        self.widthConstraint?.constant = statringFrame.width
        self.heightConstraint?.constant = statringFrame.height

        self.view.layoutIfNeeded()
        self.tabBarController?.tabBar.transform = .identity

        guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else {
          return
        }
        cell.todayCell.topConstaint.constant = 24
        cell.layoutIfNeeded()
      },
      completion: { _ in
        self.appFullscreenController.view.removeFromSuperview()
        self.appFullscreenController.removeFromParent()
        self.collectionView.isUserInteractionEnabled = true
      }
    )

  }
}

extension TodayController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 48, height: TodayController.cellSize)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}

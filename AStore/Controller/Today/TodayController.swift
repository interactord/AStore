//
//  TodayController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

  static let cellSize: CGFloat = 466

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

  var anchoredConstaints: AnchoredConstraints?

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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.superview?.setNeedsLayout()
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
        ),
        TodayItem(
          category: "HOLIDAYS",
          title: "Travel on a Budget",
          image: #imageLiteral(resourceName: "Holiday"),
          description: "Find out all you need to know on how to travel without packing everything!",
          backgroundColor: #colorLiteral(red: 0.9883298278, green: 0.962456286, blue: 0.7225952148, alpha: 1),
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

    (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
    return cell
  }

  private func showDailyListFullscreen(_ indexPath: IndexPath) {
    let fullController = TodayMultipleAppsController(mode: .fullScreen)
    fullController.apps = self.items[indexPath.item].apps
    present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    switch items[indexPath.item].cellType {
    case .multiple:
      showDailyListFullscreen(indexPath)
    default:
      showSingleAppFullscreen(indexPath)
    }
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
        self.anchoredConstaints?.top?.constant = statringFrame.origin.y
        self.anchoredConstaints?.leading?.constant = statringFrame.origin.x
        self.anchoredConstaints?.width?.constant = statringFrame.width
        self.anchoredConstaints?.height?.constant = statringFrame.height

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

  @objc func handleMultipleAppsTap(gesture: UIGestureRecognizer) {

    let collectionView = gesture.view
    var superview = collectionView?.superview

    /// find indexPath in superview(self.collectionView)
    while superview != nil {
      if let cell = superview as? TodayMultipleAppCell {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
          return
        }
        let apps = self.items[indexPath.item].apps
        let fullScreenController = TodayMultipleAppsController(mode: .fullScreen)
        fullScreenController.apps = apps
        present(BackEnabledNavigationController(rootViewController: fullScreenController), animated: true)
        return
      }
      superview = superview?.superview
    }
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

private extension TodayController {

  private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.item]
    appFullscreenController.dismissHandler = {
      self.removeFullscreenView()
    }
    appFullscreenController.view.layer.cornerRadius = 16
    self.appFullscreenController = appFullscreenController
  }

  private func setupStartingCellFrame(_ indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else {
      return
    }
    /// absolute coordinates of cell
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {
      return
    }
    self.startingFrame = startingFrame
  }

  private func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
    guard let fullscreenView = appFullscreenController.view else {
      return
    }
    view.addSubview(fullscreenView)
    addChild(appFullscreenController)
    self.collectionView.isUserInteractionEnabled = false

    setupStartingCellFrame(indexPath)

    guard let startingFrame = self.startingFrame else {
      return
    }

    anchoredConstaints = fullscreenView.anchor(
      top: view.topAnchor,
      leading: view.leadingAnchor,
      bottom: nil,
      trailing: nil,
      padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),
      size: .init(width: startingFrame.width, height: startingFrame.height)
    )

    self.view.layoutIfNeeded()

  }

  private func beginAnimationAppFullscreen() {
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {

        self.anchoredConstaints?.top?.constant = 0
        self.anchoredConstaints?.leading?.constant = 0
        self.anchoredConstaints?.width?.constant = self.view.frame.width
        self.anchoredConstaints?.height?.constant = self.view.frame.height

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

  private func showSingleAppFullscreen(_ indexPath: IndexPath) {
    /// #1
    setupSingleAppFullscreenController(indexPath)

    /// #2 setup fullscrenn in its starting positon
    setupAppFullscreenStartingPosition(indexPath)

    /// #3 begin the fullscreen animation
    beginAnimationAppFullscreen()

  }
}

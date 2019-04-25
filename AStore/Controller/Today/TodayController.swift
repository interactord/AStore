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
  let headerId = "headerId"

  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController!
  var items = [TodayItem]()
  var appFullscreenBeginOffset: CGFloat = 0

  var activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.color = .darkGray
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()

  var anchoredConstaints: AnchoredConstraints?
  let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()
    blurVisualEffectView.alpha = 0

    view.addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()

    fetchData()

    navigationController?.isNavigationBarHidden = true

    collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
    collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    collectionView.register(
      TodayHeaderCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerId
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.superview?.setNeedsLayout()
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

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    guard let header = view as? TodayHeaderCell else {
      return view
    }
    print(Date.convertFormat())

    header.dateLabel.text = Date.convertFormat()
    return header
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    switch items[indexPath.item].cellType {
    case .multiple:
      showDailyListFullscreen(indexPath)
    default:
      showSingleAppFullscreen(indexPath)
    }
  }

  func handleAppFullscreenDismissal() {

    /// access startingFrame
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {

        self.blurVisualEffectView.alpha = 0
        self.appFullscreenController.view.transform = .identity
        self.appFullscreenController.tableView.contentOffset = .zero

        guard let statringFrame = self.startingFrame else {
          return
        }
        self.anchoredConstaints?.top?.constant = statringFrame.origin.y
        self.anchoredConstaints?.leading?.constant = statringFrame.origin.x
        self.anchoredConstaints?.width?.constant = statringFrame.width
        self.anchoredConstaints?.height?.constant = statringFrame.height

        self.view.layoutIfNeeded()
        self.tabBarController?.tabBar.transform = .identity

        guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else {
          return
        }
        self.appFullscreenController.closeButton.alpha = 0
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

private extension TodayController {

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
          category: "LIFE HACK",
          title: "Utilizing your Time",
          image: #imageLiteral(resourceName: "Garden"),
          description: "All the tools and apps your need to intelligently organize your life the right way.",
          backgroundColor: .white,
          cellType: .single,
          apps: []
        ),
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
          category: "HOLIDAYS",
          title: "Travel on a Budget",
          image: #imageLiteral(resourceName: "Holiday"),
          description: "Find out all you need to know on how to travel without packing everything!",
          backgroundColor: #colorLiteral(red: 0.9883298278, green: 0.962456286, blue: 0.7225952148, alpha: 1),
          cellType: .single,
          apps: []
        ),
        TodayItem(
          category: "Daily List",
          title: gamesGroup?.feed.title ?? "",
          image: #imageLiteral(resourceName: "Garden"),
          description: "",
          backgroundColor: .white,
          cellType: .multiple,
          apps: gamesGroup?.feed.results ?? []
        )
      ]

      self.collectionView.reloadData()
    }

  }

  private func showDailyListFullscreen(_ indexPath: IndexPath) {
    let fullController = TodayMultipleAppsController(mode: .fullScreen)
    fullController.apps = self.items[indexPath.item].apps
    present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
  }

  private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.item]
    appFullscreenController.dismissHandler = {
      self.handleAppFullscreenDismissal()
    }
    appFullscreenController.view.layer.cornerRadius = 16
    self.appFullscreenController = appFullscreenController

    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
    gesture.delegate = self
    appFullscreenController.view.addGestureRecognizer(gesture)
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

        self.blurVisualEffectView.alpha = 1

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

  @objc private func handleDrag(gesture: UIPanGestureRecognizer) {

    if gesture.state == .began {
      appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
    }

    let translationY = gesture.translation(in: appFullscreenController.view).y

    if appFullscreenController.tableView.contentOffset.y > 0 {
      return
    }

    switch gesture.state {
    case .changed:
      if translationY > 0 {

        let trueOffset = translationY - appFullscreenBeginOffset
        var scale = 1 - trueOffset / 1_000

        scale = min(1, scale)
        scale = max(0.5, scale)
        let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
        self.appFullscreenController.view.transform = transform
      }
    case .ended:
      if translationY > 0 {
        handleAppFullscreenDismissal()
      }
    default: break
    }
  }
}

extension TodayController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 85)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 48, height: TodayController.cellSize)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 10, left: 0, bottom: 32, right: 0)
  }
}

extension TodayController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

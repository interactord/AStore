//
//  TodayController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

  private let cellId = "cellId"
  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController!

  let items = [
    TodayItem(
      category: "LIFE HACK",
      title: "Utilizing your Time",
      image: #imageLiteral(resourceName: "Garden"),
      description: "All the tools and apps your need to intelligently organize your life the right way.",
      backgroundColor: .white
    ),
    TodayItem(
      category: "HOLIDAYS",
      title: "Travel on a Budget",
      image: #imageLiteral(resourceName: "Holiday"),
      description: "Find out all your need to know on how to trabel without packing everything!",
      backgroundColor: #colorLiteral(red: 0.9874814153, green: 0.9665464759, blue: 0.7266566157, alpha: 1)
    )
  ]

  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true

    collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let todayCell = cell as? TodayCell else {
      return cell
    }
    todayCell.todayItem = items[indexPath.item]
    return todayCell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    guard
      let cell = collectionView.cellForItem(at: indexPath),
      let startingFrame = cell.superview?.convert(cell.frame, to: nil) /// absolute coordinates of cell
      else {
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
    return .init(width: view.frame.width - 48, height: 450)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}

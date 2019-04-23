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
  var appFullScreenController: UIViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true

    collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let todayCell = cell as? TodayCell else {
      return cell
    }
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

    let appFullScreenController = AppFullScreenController()
    guard let redView = appFullScreenController.view else {
      return
    }
    redView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView))
    )
    redView.frame = startingFrame
    redView.layer.cornerRadius = 16
    view.addSubview(redView)
    addChild(appFullScreenController)

    self.appFullScreenController = appFullScreenController

    /// why i don't use a transition delegate?

    /// we're using frames for animation
    /// frame aren't reliable enough for animations

    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        redView.frame = self.view.frame

        self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
      }
    )
  }

  @objc func handleRemoveRedView(getsture: UITapGestureRecognizer) {

    /// access startingFrame
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        getsture.view?.frame = self.startingFrame ?? .zero
        self.tabBarController?.tabBar.transform = .identity
      },
      completion: { _ in
        getsture.view?.removeFromSuperview()
        self.appFullScreenController.removeFromParent()
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

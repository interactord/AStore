//
//  TodayMultipleController.swift
//  AStore
//
//  Created by SANGBONG MOON on 24/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {

  enum Mode {
    case small, fullScreen
  }
  private let mode: Mode
  private let cellId = "cellId"
  private let spacing: CGFloat = 12
  let closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "Close-button"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "Close-button").alpha(0.5), for: .highlighted)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  var results = [FeedResult]()

  override var prefersStatusBarHidden: Bool {
    return true
  }

  init(mode: Mode) {
    self.mode = mode
    super.init()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if mode == .fullScreen {
      setupCloseButton()
    } else {
      collectionView.isScrollEnabled = false
    }

    collectionView.backgroundColor = .white
    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
  }

  @objc func handleDismiss() {
    dismiss(animated: true)
  }

  private func setupCloseButton() {
    view.addSubview(closeButton)
    closeButton.anchor(
      top: view.topAnchor,
      leading: nil,
      bottom: nil,
      trailing: view.trailingAnchor,
      padding: .init(top: 28, left: 0, bottom: 0, right: 16),
      size: .init(width: 44, height: 44)
    )
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if mode == .fullScreen {
      return results.count
    }
    return min(4, results.count)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let mutipleAppCell = cell as? MultipleAppCell else {
      return cell
    }
    mutipleAppCell.app = results[indexPath.item]
    return mutipleAppCell
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let height: CGFloat = 68

    if mode == .fullScreen {
      return .init(width: view.frame.width - 48, height: height)
    }

    return .init(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if mode == .fullScreen {
      return .init(top: 12, left: 24, bottom: 12, right: 24)
    }

    return .zero
  }
}

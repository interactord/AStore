//
//  AppFullScreenController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController {

  var dismissHandler: (() -> Void)?
  var todayItem: TodayItem?
  let tableView = UITableView(frame: .zero, style: .plain)

  let closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "Close-button"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "Close-button").alpha(0.5), for: .highlighted)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()

  let floatingContainerView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.clipsToBounds = true

    view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.dataSource = self
    tableView.delegate = self

    setupCloseButton()

    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.contentInsetAdjustmentBehavior = .never
    let height = UIApplication.shared.statusBarFrame.height
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)

    setupFloatingControllers()
  }

  @objc func handleDismiss(button: UIButton) {
    button.isHidden = true
    dismissHandler?()
  }

}

private extension AppFullscreenController {

  private func setupCloseButton() {

    view.addSubview(closeButton)
    closeButton.anchor(
      top: view.safeAreaLayoutGuide.topAnchor,
      leading: nil,
      bottom: nil,
      trailing: view.trailingAnchor,
      padding: .init(top: 12, left: 0, bottom: 0, right: 0),
      size: .init(width: 80, height: 40)
    )

  }

  private func setupFloatingControllers() {

    floatingContainerView.clipsToBounds = true
    floatingContainerView.layer.cornerRadius = 16

    view.addSubview(floatingContainerView)

//    let bottomPadding = UIApplication.shared.statusBarFrame.height

    floatingContainerView.anchor(
      top: nil,
      leading: view.leadingAnchor,
      bottom: view.bottomAnchor,
      trailing: view.trailingAnchor,
      padding: .init(top: 0, left: 16, bottom: -90, right: 16),
      size: .init(width: 0, height: 90)
    )

    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    floatingContainerView.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()

    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    // add our views
    let imageView = UIImageView(cornerRadius: 16)
    imageView.image = todayItem?.image
    imageView.constrainHeight(constant: 68)
    imageView.constrainWidth(constant: 68)

    let getButton = UIButton(title: "GET")
    getButton.setTitleColor(.white, for: .normal)
    getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    getButton.backgroundColor = .darkGray
    getButton.layer.cornerRadius = 16
    getButton.constrainWidth(constant: 80)
    getButton.constrainHeight(constant: 32)

    let stackView = UIStackView(arrangedSubViews: [
      imageView,
      VerticalStackView(arrangedSubviews: [
        UILabel(text: "Life hack", font: .boldSystemFont(ofSize: 18)),
        UILabel(text: "Utilizing your Time", font: .systemFont(ofSize: 16))
      ], spacing: 4),
      getButton
    ], customSpacing: 16)

    floatingContainerView.addSubview(stackView)
    stackView.fillSuperview(
      padding: .init(top: 0, left: 16, bottom: 0, right: 16)
    )
    stackView.alignment = .center
  }

  @objc private func handleTap() {
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        self.floatingContainerView.transform = .init(translationX: 0, y: -90)
      }
    )
  }
}

extension AppFullscreenController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.item == 0 {
      let headerCell = AppFullscreenHeaderCell()
      headerCell.todayCell.todayItem = todayItem
      headerCell.todayCell.layer.cornerRadius = 0
      headerCell.clipsToBounds = true
      headerCell.todayCell.backgroundView = nil
      return headerCell
    }

    let cell = AppFullscreenDescriptionCell()
    cell.backgroundColor = .white
    return cell
  }
}

extension AppFullscreenController: UITableViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.isScrollEnabled = true
    }

    let translationY = -90 - UIApplication.shared.statusBarFrame.height
    let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveEaseOut,
      animations: {
        self.floatingContainerView.transform = transform
      }
    )
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.item == 0 {
      return TodayController.cellSize
    }
    return UITableView.automaticDimension
  }
}

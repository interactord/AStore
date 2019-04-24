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
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.item == 0 {
      return TodayController.cellSize
    }
    return UITableView.automaticDimension
  }
}

//
//  AppFullScreenController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {

  var dismissHandler: (() -> Void)?
  var todayItem: TodayItem?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.contentInsetAdjustmentBehavior = .never
    let height = UIApplication.shared.statusBarFrame.height
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.isScrollEnabled = true
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.item == 0 {
      let headerCell = AppFullscreenHeaderCell()
      headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
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

  @objc func handleDismiss(button: UIButton) {
    button.isHidden = true
    dismissHandler?()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.item == 0 {
      return TodayController.cellSize
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
}

//
//  AppFullScreenController.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.item == 0 {
      return AppFullscreenHeaderCell()
    }

    let cell = AppFullscreenDescriptionCell()
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.item == 0 {
      return 450
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
}

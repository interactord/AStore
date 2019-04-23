//
//  AppFullScreenHEaderCell.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {

  let todayCell = TodayCell()
  let closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "close-button"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "close-button").alpha(0.5), for: .highlighted)
    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    addSubview(todayCell)
    todayCell.fillSuperview()
    addSubview(closeButton)
    closeButton.anchor(
      top: topAnchor,
      leading: nil,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 16, left: 0, bottom: 0, right: 16),
      size: .init(width: 80, height: 30)
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

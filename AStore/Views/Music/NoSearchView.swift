//
//  NoSearchView.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class NoSearchView: UIView {

  let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .lightGray

    activityIndicatorView.hidesWhenStopped = true
    addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

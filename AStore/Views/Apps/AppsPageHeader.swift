//
//  AppsPageHeader.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {

  let appsHeaderHorizontalController = AppsHeaderHorizontalController()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(appsHeaderHorizontalController.view)
    appsHeaderHorizontalController.view.fillSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

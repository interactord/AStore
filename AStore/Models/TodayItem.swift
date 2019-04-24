//
//  TodayItem.swift
//  AStore
//
//  Created by SANGBONG MOON on 23/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

struct TodayItem {
  enum CellType: String {
    case single, multiple
  }

  let category: String
  let title: String
  let image: UIImage
  let description: String
  let backgroundColor: UIColor
  let cellType: CellType
  let apps: [FeedResult]
}

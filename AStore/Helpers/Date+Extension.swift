//
//  NSDate+Extension.swift
//  AStore
//
//  Created by SANGBONG MOON on 25/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import Foundation

extension Date {
  static func convertFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    let newDate = dateFormatter.string(from: Date())

    return newDate
  }
}

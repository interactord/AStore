//
//  AppGroup.swift
//  AStore
//
//  Created by SANGBONG MOON on 22/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
  let feed: Feed
}

struct Feed: Decodable {

  let title: String
  let results: [FeedResult]
}

struct FeedResult: Decodable {
  let name, artistName, artworkUrl100: String
}

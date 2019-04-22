//
//  SearchResult.swift
//  AStore
//
//  Created by SANGBONG MOON on 21/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  let resultCount: Int
  let results: [SearchResultResponse]
}

struct SearchResultResponse: Decodable {
  let trackId: Int
  let trackName: String
  let primaryGenreName: String
  var averageUserRating: Float?
  let screenshotUrls: [String]
  let artworkUrl100: String /// app icon
  var formattedPrice: String?
  let description: String
  var releaseNotes: String?
}

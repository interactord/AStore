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
  var screenshotUrls: [String]?
  let artworkUrl100: String /// app icon
  var formattedPrice: String?
  var description: String?
  var releaseNotes: String?
  var artistName: String?
  var collectionName: String?
}

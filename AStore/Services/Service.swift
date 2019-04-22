//
//  Service.swift
//  AStore
//
//  Created by SANGBONG MOON on 21/04/2019.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import Foundation

class Service {

  static let shared = Service() // Singleton

  func fetchApps(searchTerm: String, completion: @escaping ([SearchResultResponse], Error?) -> Void) {

    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
    guard let url = URL(string: urlString) else {
      return
    }

    // fetch data from internet
    URLSession.shared.dataTask(with: url) { data, _, err in
      /// error
      if let err = err {
        completion([], err)
        return
      }

      /// success
      guard let data = data else { return }

      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        completion(searchResult.results, nil)
      } catch {
        completion([], error)
      }

    }.resume() // fires off the request

  }

  func fetchGames(completion: @escaping (AppGroup?, Error?) -> Void) {
//    let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
    let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
    guard let url = URL(string: urlString) else {
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, err in

      if let err = err {
        completion(nil, err)
        return
      }

      do {
        guard let data = data else { return }
        let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
        completion(appGroup, nil)
      } catch {
        completion(nil, error)
      }

    }.resume()
  }

}

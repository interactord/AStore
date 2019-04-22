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
    let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
    fetchAppGroup(urlString: urlString, completion: completion)
  }

  func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> Void) {
    let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
    fetchAppGroup(urlString: urlString, completion: completion)
  }

  /// helper
  func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
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

  func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
    let urlString = "https://gist.githubusercontent.com/interactord/406f7daa408f292e6d1fced9783e1033/raw/93b2a7e9dd8452a3e0ed4ec01d41c3d1584a8cdd/appsHeader.json"
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
        let socialApps = try JSONDecoder().decode([SocialApp].self, from: data)
        completion(socialApps, nil)
      } catch {
        completion(nil, error)
      }
    }.resume()

  }

}

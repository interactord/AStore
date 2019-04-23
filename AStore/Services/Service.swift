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

  func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> Void) {
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
    fetchGenericJSONData(urlString: urlString, completaion: completion)

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
    fetchGenericJSONData(urlString: urlString, completaion: completion)
  }

  func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
    let urlString = "https://s3.ap-northeast-2.amazonaws.com/astore.interactord.io/apps-banner/appsHeadBanner.json"

    fetchGenericJSONData(urlString: urlString, completaion: completion)

  }
}

extension Service {
  func fetchGenericJSONData<T: Decodable>(urlString: String, completaion: @escaping (T?, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, err in
      if let err = err {
        completaion(nil, err)
        return
      }

      do {
        guard let data = data else {
          return
        }
        let objects = try JSONDecoder().decode(T.self, from: data)
        completaion(objects, nil)
      } catch {
        completaion(nil, error)
      }
    }.resume()
  }
}

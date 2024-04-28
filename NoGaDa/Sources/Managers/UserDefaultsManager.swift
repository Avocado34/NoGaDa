//
//  UserDefaultsManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/03/28.
//

import Foundation


struct UserDefaultsManager {
  
  enum Key: String {
    case searchBrand = "search.filter.search_brand"
    case searchWithTitle = "search.filter.search_with_title"
    case searchWithSinger = "search.filter.search_with_singer"
  }
  
  @UserDefaultEnum(key: Key.searchBrand.rawValue, defaultValue: .tj) static var searchBrand: KaraokeBrand
  @UserDefault(key: Key.searchWithTitle.rawValue, defaultValue: true) static var searchWithTitle: Bool
  @UserDefault(key: Key.searchWithSinger.rawValue, defaultValue: true) static var searchWithSinger: Bool
}

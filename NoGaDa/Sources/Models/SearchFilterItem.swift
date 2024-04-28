//
//  SearchFilterItem.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/21.
//

import UIKit


protocol SearchFilterItem {
  var title: String { get }
  var state: Bool { get }
  func toggleState()
}


// MARK: - Search with Title

struct SearchWithTitleItem: SearchFilterItem {
  
  var title: String = "🏷 제목으로 검색"
  var state: Bool {
    UserDefaultsManager.searchWithTitle
  }
  
  func toggleState() {
    UserDefaultsManager.searchWithTitle.toggle()
  }
}


// MARK: - Search with Singer

struct SearchWithSingerItem: SearchFilterItem {
  
  var title: String = "🙋 가수 명으로 검색"
  var state: Bool {
    UserDefaultsManager.searchWithSinger
  }
  
  func toggleState() {
    UserDefaultsManager.searchWithSinger.toggle()
  }
}

//
//  SearchHistory.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/10.
//

import RealmSwift


final class SearchHistory: Object {
  
  // MARK: - Properties
  
  @objc dynamic var keyword: String = ""
  @objc dynamic var date: Date = Date()
  
  
  // MARK: - Initializers
  
  convenience init(keyword: String) {
    self.init()
    
    self.keyword = keyword
  }
  
  
  // MARK: - Methods
  
  override class func primaryKey() -> String? {
    return "keyword"
  }
}

//
//  ArchiveFolder.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import RealmSwift


final class ArchiveFolder: Object {
  
  // MARK: - Properties
  
  @objc dynamic var id:           String = UUID().uuidString
  @objc dynamic var title:        String = ""
  @objc dynamic var titleEmoji:   String = ""
  let songs = List<ArchiveSong>()
  
  
  // MARK: - Initializers
  
  convenience init(title: String, titleEmoji: String) {
    self.init()
    
    self.title      = title
    self.titleEmoji = titleEmoji
  }
  
  
  // MARK: - Methods
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override class func indexedProperties() -> [String] {
    return ["id", "title", "titleEmoji"]
  }
}

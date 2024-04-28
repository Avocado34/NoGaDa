//
//  ArchiveSong.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import RealmSwift


final class ArchiveSong: Object {
  
  // MARK: - Properties
  
  @objc dynamic var id:           String = UUID().uuidString
  @objc dynamic var no:           String = ""
  @objc dynamic var title:        String = ""
  @objc dynamic var singer:       String = ""
  @objc dynamic var brand:        String = ""
  @objc dynamic var composer:     String = ""
  @objc dynamic var lyricists:    String = ""
  @objc dynamic var releaseDate:  String = ""
  
  
  // MARK: - Initializers
  
  convenience init(no: String, title: String, singer: String, brand: String, composer: String, lyricists: String, releaseDate: String) {
    self.init()
    self.no             = no
    self.title          = title
    self.singer         = singer
    self.brand          = brand
    self.composer       = composer
    self.lyricists      = lyricists
    self.releaseDate    = releaseDate
  }
  
  
  // MARK: - Methods
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override class func indexedProperties() -> [String] {
    return ["id", "no", "title", "singer", "brand", "composer", "lyricists", "release"]
  }
  
  public func asSongType() -> Song {
    let song = Song(brand: KaraokeBrand(rawValue: brand) ?? .tj, no: no, title: title, singer: singer, composer: composer, lyricist: lyricists, release: releaseDate)
    
    return song
  }
}

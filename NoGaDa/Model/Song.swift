//
//  Song.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import UIKit

struct Song: Equatable, Codable, Hashable {
    let brand:      String
    let no:         String
    let title:      String
    let singer:     String
    let composer:   String
    let lyricist:   String
    let release:    String
}

//
//  KaraokeBrand.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import UIKit


enum KaraokeBrand: String, Decodable, CaseIterable {
  case tj       = "tj"
  case kumyoung = "금영"
  
  enum CodingKeys: String, CodingKey {
    case tj
    case kumyoung = "kumyoung"
  }
  
  
  // MARK: - Properties
  
  var path: String {
    switch self {
    case .tj:
      return "/tj.json"
      
    case .kumyoung:
      return "/kumyoung.json"
    }
  }
  
  var localizedString: String {
    switch self {
    case .tj:
      return "tj"
      
    case .kumyoung:
      return "금영"
    }
  }
}

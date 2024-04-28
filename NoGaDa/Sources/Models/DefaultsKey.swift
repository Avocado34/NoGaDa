//
//  MyDefaults.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/09/01.
//

import Foundation


enum DefaultsKey: String {
  case launchCount = "com.app.launchcount"
  
  var name: String {
    return self.rawValue
  }
}

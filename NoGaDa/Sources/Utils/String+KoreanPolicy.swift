//
//  String+KoreanPolicy.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/10/19.
//

import Foundation


extension String {
  func isKorean() -> Bool {
    let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣0-9\\s]{0,}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
    return predicate.evaluate(with: self)
  }
  
  mutating func removeAllEmptySpaces() {
    self = self.replacingOccurrences(of: " ", with: "")
  }
  
  var fullRange: NSRange {
    return NSMakeRange(0, self.count)
  }
}

//
//  UILabel+AccentColor.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UILabel {
  func setAccentColor(string: String) {
    guard let text = self.text else { return }
    
    DispatchQueue.global(qos: .background).async {
      let attributedString = NSMutableAttributedString(string: text)
      attributedString.addAttribute(.foregroundColor, value: R.color.accentPink()!,
                                    range: (text.lowercased() as NSString).range(of: string.lowercased()))
      
      DispatchQueue.main.async {
        self.attributedText = attributedString
      }
    }
  }
  
  func releaseAccentColor(with releaseColor: UIColor) {
    guard let text = self.text else { return }
    
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(.foregroundColor, value: releaseColor,
                                  range: (text as NSString).range(of: text))
    self.attributedText = attributedString
  }
}

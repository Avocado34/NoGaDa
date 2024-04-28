//
//  UITextField+PlaceholderColor.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UITextField {
  func setPlaceholderColor(_ color: UIColor) {
    guard let placeholder = self.placeholder else { return }
    
    self.attributedPlaceholder =
    NSAttributedString(string: placeholder,
                       attributes: [NSAttributedString.Key.foregroundColor : color])
  }
}

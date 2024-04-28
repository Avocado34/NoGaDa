//
//  UISegmentedControl+Focus.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UISegmentedControl {
  func setSelectedTextColor(_ color: UIColor) {
    self.setTitleTextAttributes([.foregroundColor : color], for: .selected)
  }
  
  func setDefaultTextColor(_ color: UIColor) {
    self.setTitleTextAttributes([.foregroundColor : color], for: .normal)
  }
}

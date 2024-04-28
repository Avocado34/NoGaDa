//
//  UIView+TapAnimate.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/28.
//

import UIKit


extension UIView {
  func scaleDown() {
    self.transform = .init(scaleX: 0.975, y: 0.975)
  }
  
  func releaseScale() {
    self.transform = .init(scaleX: 1, y: 1)
  }
}

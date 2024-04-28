//
//  UIButton+Padding.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UIButton {
  func setPadding(width: CGFloat) {
    self.imageEdgeInsets = UIEdgeInsets(top: width, left: width, bottom: width, right: width)
  }
}


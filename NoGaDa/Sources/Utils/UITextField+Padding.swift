//
//  UITextField+Padding.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UITextField {
  func setLeftPadding(width: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
  
  func setRightPadding(width: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }
}

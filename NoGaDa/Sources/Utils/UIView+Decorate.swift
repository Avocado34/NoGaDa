//
//  UIView+Decorate.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UIView {
  func makeAsCircle() {
    self.layer.cornerRadius = self.frame.width / 2
  }
  
  func setAppBarShadow() {
    self.layer.shadowColor = R.color.accentPurple()!.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 12
    self.layer.shadowOpacity = 0.4
  }
  
  func setSearchBoxShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 12
    self.layer.shadowOpacity = 0.1
  }
  
  func setSearchBoxButtonShadow() {
    self.layer.shadowColor = R.color.accentPurple()!.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 4
    self.layer.shadowOpacity = 0.3
  }
  
  func setExitButtonShadow() {
    self.layer.shadowColor = R.color.accentPurple()!.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 16
    self.layer.shadowOpacity = 0.2
  }
  
  func setReversedExitButtonShadow() {
    self.layer.shadowColor = R.color.iconBasic()!.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 20
    self.layer.shadowOpacity = 0.4
  }
}

//
//  UIActivityIndicatorView+Toggle.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UIActivityIndicatorView {
  func startAnimatingAndShow() {
    self.startAnimating()
    self.isHidden = false
  }
  
  func stopAnimatingAndHide() {
    self.isHidden = true
    self.stopAnimating()
  }
}

//
//  UIScrollView+ScrollToTop.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UITableView {
  func scrollToTopCell(animated: Bool) {
    let indexPath = IndexPath(row: 0, section: 0)
    self.scrollToRow(at: indexPath, at: .top, animated: animated)
  }
}

extension UIScrollView {
  func scrollToTop(animated: Bool) {
    let topOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(topOffset, animated: animated)
  }
}

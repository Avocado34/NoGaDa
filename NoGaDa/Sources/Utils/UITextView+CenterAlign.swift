//
//  UITextView+CenterAlign.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import UIKit


extension UITextView {
  func centerVertically() {
    let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let size = sizeThatFits(fittingSize)
    let topOffset = (bounds.size.height - size.height * zoomScale) / 2
    let positiveTopOffset = max(1, topOffset)
    contentOffset.y = -positiveTopOffset
  }
}

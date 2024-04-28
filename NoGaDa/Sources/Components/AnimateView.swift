//
//  Animate.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/28.
//

import UIKit


class AnimateView: UIView {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      self.scaleDown()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      self.releaseScale()
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      self.releaseScale()
    }
  }
}

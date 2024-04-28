//
//  AnimateButton.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/28.
//

import UIKit


class AnimateButton: UIButton {
  
  // MARK: - Metrics
  
  static let ANIMATION_DURATION_TAP: CGFloat = 0.2
  static let ANIMATION_DURATION_RELEASE_TAP: CGFloat = 0.15
  
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupTargets()
  }
  
  private func setupTargets() {
    self.addTarget(self, action: #selector(didTapButton(_:)), for: .touchDown)
    self.addTarget(self, action: #selector(didTapRelease(_:)), for: [.touchCancel, .touchDragExit])
  }
  
  
  // MARK: - Methods
  
  @objc func didTapButton(_ sender: Any) {
    UIView.animate(withDuration: Self.ANIMATION_DURATION_TAP,
                   delay: 0,
                   options: .curveEaseInOut) {
      self.scaleDown()
    }
  }
  
  @objc func didTapRelease(_ sender: Any) {
    UIView.animate(withDuration: Self.ANIMATION_DURATION_RELEASE_TAP,
                   delay: 0,
                   options: .curveEaseInOut) {
      self.releaseScale()
    }
  }
}

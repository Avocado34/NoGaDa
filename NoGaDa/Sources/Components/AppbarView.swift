//
//  AppBarView.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/28.
//

import UIKit

import RxSwift
import RxCocoa

import Hero


class AppBarView: UIView {
  
  // MARK: - Properties
  
  private var _roundCorners: UIRectCorner = []
  private var _cornerRadius: CGFloat = 0
  private let maskLayer = CAShapeLayer()
  private let shadowLayer = CALayer()
  
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    configure(cornerRadius: _cornerRadius, roundCorners: _roundCorners)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
    configure(cornerRadius: _cornerRadius, roundCorners: _roundCorners)
  }
  
  
  // MARK: - LifeCycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    configure(cornerRadius: _cornerRadius, roundCorners: _roundCorners)
  }
  
  
  // MARK: - Setup
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupHero()
  }
  
  private func setupHero() {
    hero.id = "appbar"
  }
  
  
  // MARK: - Method
  
  func configure(cornerRadius: CGFloat = 0, roundCorners: UIRectCorner = []) {
    _cornerRadius = cornerRadius
    _roundCorners = roundCorners
    
    // Mask corners
    let path = UIBezierPath(roundedRect: frame,
                            byRoundingCorners: _roundCorners,
                            cornerRadii: CGSize(width: _cornerRadius, height: _cornerRadius))
    maskLayer.fillColor = R.color.accentPurple()!.cgColor
    maskLayer.frame = bounds
    maskLayer.path = path.cgPath
    maskLayer.shadowColor = R.color.accentPurple()!.cgColor
    maskLayer.shadowOffset = .zero
    maskLayer.shadowRadius = 2
    maskLayer.shadowOpacity = 0.2
    layer.insertSublayer(maskLayer, at: 0)
  }
}

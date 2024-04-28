//
//  HighlightingTextfield.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/07.
//

import UIKit

import RxSwift
import RxCocoa


class HighlightingTextfield: UITextField {
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  private static let cornerRadius: CGFloat = 12
  
  
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
    initView()
    bind()
  }
  
  private func initView() {
    self.layer.cornerRadius = HighlightingTextfield.cornerRadius
  }
  
  private func bind() {
    self.rx.controlEvent(.editingDidBegin)
      .bind(onNext: { [weak self] in
        self?.highlightTextField(R.color.accentColor()!)
      }).disposed(by: disposeBag)
    
    self.rx.controlEvent(.editingDidEnd)
      .bind(onNext: { [weak self] in
        self?.unhighlightTextField()
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Methods
}


// MARK: - Extensions

extension HighlightingTextfield {
  func highlightTextField(_ color: UIColor) {
    layer.borderWidth = 1
    layer.borderColor = color.cgColor
  }
  
  func unhighlightTextField() {
    layer.borderWidth = 0
  }
}

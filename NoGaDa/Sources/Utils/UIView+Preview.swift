//
//  UIView+Preview.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/04.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI


struct UIViewPreview<View: UIView>: UIViewRepresentable {
  let view: View
  
  init(_ builder: @escaping () -> View) {
    view = builder()
  }
  
  // MARK: - UIViewRepresentable
  
  func makeUIView(context: Context) -> UIView {
    return view
  }
  
  func updateUIView(_ view: UIView, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}
#endif

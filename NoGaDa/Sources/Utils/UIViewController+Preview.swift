//
//  UIViewController+Preview.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/04.
//


#if canImport(SwiftUI) && DEBUG
import SwiftUI


extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
  }
  
  func toPreview() -> some View {
    Preview(viewController: self)
  }
}
#endif

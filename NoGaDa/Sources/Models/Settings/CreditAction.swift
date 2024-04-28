//
//  CreditAction.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/28.
//

import UIKit


class CreditAction: SettingAction {
  var title: String {
    return "크레딧"
  }
  
  var icon: UIImage {
    return R.image.form()!
  }
  
  var iconContainerColor: UIColor {
    return R.color.iconBasic()!
  }
  
  func performAction(on vc: UIViewController) {
    let storyboard = UIStoryboard(name: "Setting", bundle: Bundle.main)
    let creditVC = storyboard.instantiateViewController(identifier: "creditStoryboard") { coder -> CreditViewController in
      let viewModel = CreditViewModel()
      return .init(coder, viewModel) ?? CreditViewController(viewModel)
    }
    vc.present(creditVC, animated: true, completion: nil)
  }
}


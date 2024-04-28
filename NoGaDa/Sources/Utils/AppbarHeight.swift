//
//  AppBarHeight.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/06/14.
//

import UIKit


final class AppBarHeight {
  static var compactAppBarHeight: CGFloat {
    return safeAreaTop + 80
  }
  
  static var regularAppBarHeight: CGFloat {
    return safeAreaTop + 132
  }
  
  static var safeAreaTop: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
  }
}

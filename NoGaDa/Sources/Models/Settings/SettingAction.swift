//
//  SettingAction.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/28.
//

import UIKit


protocol SettingAction {
  var title: String { get }
  var icon: UIImage { get }
  var iconContainerColor: UIColor { get }
  func performAction(on vc: UIViewController)
}

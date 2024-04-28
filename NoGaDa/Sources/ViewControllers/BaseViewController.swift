//
//  BaseViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/06/11.
//

import UIKit

import RxSwift
import RxCocoa

import AppTrackingTransparency


class BaseViewController: UIViewController {
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public let compactAppBarHeight: CGFloat = AppBarHeight.compactAppBarHeight
  public let regularAppBarHeight: CGFloat = AppBarHeight.regularAppBarHeight
  
  
  // MARK: - StatusBarStyle
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  // MARK: - Methods
  
  public func requestTrackingAuthorization() {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { _ in }
    }
  }
}

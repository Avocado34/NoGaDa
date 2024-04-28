//
//  UIViewController+Rx.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/21.
//

import UIKit

import RxSwift
import RxCocoa


extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewWillAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear(_:)))
      .map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
  
  var viewDidAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewDidAppear(_:)))
      .map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
  
  var viewWillDisappear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:)))
      .map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
}

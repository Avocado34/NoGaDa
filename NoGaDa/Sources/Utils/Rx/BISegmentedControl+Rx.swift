//
//  BISegmentedControl+Rx.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/21.
//

import RxSwift
import RxCocoa

import BISegmentedControl


final class RxBISegmentedControlDelegateProxy: DelegateProxy<BISegmentedControl, BISegmentedControlDelegate>,
                                         DelegateProxyType,
                                         BISegmentedControlDelegate {
  static func registerKnownImplementations() {
    self.register { biSegmentedControl -> RxBISegmentedControlDelegateProxy in
      RxBISegmentedControlDelegateProxy(parentObject: biSegmentedControl, delegateProxy: self)
    }
  }
  
  static func currentDelegate(for object: BISegmentedControl) -> BISegmentedControlDelegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: BISegmentedControlDelegate?, to object: BISegmentedControl) {
    object.delegate = delegate
  }
}

extension Reactive where Base: BISegmentedControl {
  var rx_delegate: DelegateProxy<BISegmentedControl, BISegmentedControlDelegate> {
    return RxBISegmentedControlDelegateProxy.proxy(for: self.base)
  }
  
  var itemSelected: Observable<Int?> {
    return rx_delegate.sentMessage(#selector(BISegmentedControlDelegate.BISegmentedControl(didSelectSegmentAt:)))
      .map { a in
        return a.first as? Int
      }
  }
}

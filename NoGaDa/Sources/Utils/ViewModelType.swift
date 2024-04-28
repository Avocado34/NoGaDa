//
//  ViewModelType.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/21.
//

import RxSwift


protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  var input: Input! { get }
  var output: Output! { get }
  
  var disposeBag: DisposeBag { get }
}

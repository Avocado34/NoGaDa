//
//  ViewModelInjectable.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/06/11.
//

import UIKit


protocol ViewModelInjectable {
  
  // MARK: - Properties
  
  associatedtype ViewModel: AnyObject
  var viewModel: ViewModel { get set }
  
  
  // MARK: - Initializers
  
  init(_ viewModel: ViewModel)
  
  init?(_ coder: NSCoder, _ viewModel: ViewModel)
}

//
//  CreditViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/08.
//

import UIKit

import RxSwift
import RxCocoa


final class CreditViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let tapExitButton = PublishSubject<Void>()
    let tapContactButton = PublishSubject<Void>()
  }
  
  struct Output {
    let dismiss = PublishRelay<Void>()
    let showingMailComposeVC = PublishRelay<(recipients: [String], subject: String)>()
    let iconResources = BehaviorRelay<[ResourceItem]>(value: ResourceItem.allCases)
  }
  
  static let developerEmail = "avocado.34.131@gmail.com"
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  
  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    input.tapExitButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  public var appVersion: String {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return appVersion
    } else {
      return "-.-.-"
    }
  }
}

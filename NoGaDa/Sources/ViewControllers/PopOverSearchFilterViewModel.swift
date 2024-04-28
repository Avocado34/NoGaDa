//
//  PopOverSearchFilterViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/06/11.
//

import Foundation

import RxSwift
import RxCocoa


final class PopOverSearchFilterViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let tapApplyButton = PublishSubject<Void>()
    let updateKaraokeBrand = PublishSubject<KaraokeBrand>()
  }
  
  struct Output {
    let searchFilterItems = BehaviorRelay<[SearchFilterItem]>(value: [
      SearchWithTitleItem(),
      SearchWithSingerItem()
    ])
    let didTapApplyButton = PublishRelay<Bool>()
    let dismiss = PublishRelay<Void>()
  }
  
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
    
    input.tapApplyButton
      .subscribe(onNext: {
        output.didTapApplyButton.accept(true)
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.updateKaraokeBrand
      .subscribe(onNext: { brand in
        UserDefaultsManager.searchBrand = brand
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
}

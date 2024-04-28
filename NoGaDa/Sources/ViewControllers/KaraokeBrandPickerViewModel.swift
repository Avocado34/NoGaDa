//
//  BrandPickerViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/01/05.
//

import UIKit

import RxSwift
import RxCocoa


final class KaraokeBrandPickerViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let tapKaraokeBrandItem = PublishSubject<IndexPath>()
  }
  
  struct Output {
    let karaokeBrands = BehaviorRelay<[KaraokeBrand]>(value: KaraokeBrand.allCases)
    let didTapKaraokeBrandItem = PublishRelay<KaraokeBrand>()
    let dismiss = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  
  
  // MARK: - LifeCycle
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    input.tapKaraokeBrandItem
      .subscribe(onNext: { indexPath in
        let selectedBrand = output.karaokeBrands.value[indexPath.row]
        output.didTapKaraokeBrandItem.accept(selectedBrand)
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    
    self.input = input
    self.output = output
  }
}

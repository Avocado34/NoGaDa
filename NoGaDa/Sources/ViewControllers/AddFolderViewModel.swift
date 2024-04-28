//
//  AddFolderViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import Foundation

import RxSwift
import RxCocoa


final class AddFolderViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let tapExitButton = PublishSubject<Void>()
    let folderEmoji = BehaviorRelay<String>(value: "")
    let folderTitle = BehaviorRelay<String>(value: "")
    let tapConfirmButton = PublishSubject<Void>()
  }
  
  struct Output {
    let dismiss = PublishRelay<Void>()
    let isConfirmButtonActive = BehaviorRelay<Bool>(value: false)
    let didFolderAdded = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let folderManager = SongFolderManager()
  
  
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
    
    Observable.merge(
      input.folderEmoji.asObservable(),
      input.folderTitle.asObservable()
    )
    .flatMap { _ -> Observable<Bool> in
      return Observable.combineLatest(input.folderEmoji, input.folderTitle, resultSelector: { !$0.isEmpty && !$1.isEmpty })
    }
    .subscribe(onNext: { isAllTextFieldFilled in
      if isAllTextFieldFilled {
        output.isConfirmButtonActive.accept(true)
      } else {
        output.isConfirmButtonActive.accept(false)
      }
    })
    .disposed(by: disposeBag)
    
    input.tapConfirmButton
      .flatMap { [weak self] () -> Observable<Void> in
        guard let self = self else { return .never() }
        return self.folderManager
          .addData(title: input.folderTitle.value,
                   titleEmoji: input.folderEmoji.value)
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.didFolderAdded.accept(Void())
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  func addFolder(_ title: String, _ titleEmoji: String) -> Completable {
    return Completable.create { [weak self] observer in
      guard let self = self else { return Disposables.create() }
      
      self.folderManager.addData(title: title, titleEmoji: titleEmoji)
        .subscribe(onCompleted: {
          observer(.completed)
        }, onError: { error in
          observer(.error(error))
        }).disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
}

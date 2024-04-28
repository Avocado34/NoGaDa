//
//  SearchHistoryViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import Foundation

import RxSwift
import RxCocoa


final class SearchHistoryViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let refresh = PublishRelay<Void>()
    let tapHistoryItem = PublishSubject<IndexPath>()
    let tapClearHistoryButton = PublishSubject<Void>()
  }
  
  struct Output {
    let searchHistories = BehaviorRelay<[SearchHistory]>(value: [])
    let didTapHistoryItem = PublishRelay<SearchHistory>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let searchHistoryManager = SearchHistoryManager()
  
  
  // MARK: - LifeCycle
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Pirvate
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    Observable.merge(
      input.viewDidLoad.asObservable(),
      input.refresh.asObservable()
    )
    .flatMap { [weak self] () -> Single<[SearchHistory]> in
      guard let self = self else { return .never() }
      return self.searchHistoryManager
        .fetchData()
    }
    .subscribe(onNext: { searchHistories in
      output.searchHistories.accept(searchHistories)
    })
    .disposed(by: disposeBag)
    
    input.tapHistoryItem
      .subscribe(onNext: { indexPath in
        let selectedItem = output.searchHistories.value[indexPath.row]
        output.didTapHistoryItem.accept(selectedItem)
      })
      .disposed(by: disposeBag)
    
    input.tapClearHistoryButton
      .flatMap { [weak self] () -> Observable<Void> in
        guard let self = self else { return .never() }
        return self.searchHistoryManager
          .deleteAll()
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.searchHistories.accept([])
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  public func deleteHistory(_ index: Int) {
    var histories = output.searchHistories.value
    let selectedItem = histories.remove(at: index)
    
    searchHistoryManager.deleteData(selectedItem)
      .subscribe(with: self, onCompleted: { strongSelf in
        strongSelf.output.searchHistories.accept(histories)
      }, onError: { strongSelf, error in
        print(error.localizedDescription)
      })
      .disposed(by: self.disposeBag)
  }
}

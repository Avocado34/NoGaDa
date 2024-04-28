//
//  SearchViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import UIKit

import RxSwift
import RxCocoa


final class SearchViewModel: ViewModelType {
  
  // MARK: - Properties
  
  enum ContentType: Equatable {
    case searchHistory
    case searchResult(String)
  }
  
  struct Input {
    var tapBackButton = PublishRelay<Void>()
    var tapFilterButton = PublishRelay<Void>()
    var tapClearButton = PublishRelay<Void>()
    var editTextField = PublishRelay<String>()
    var search = PublishRelay<Void>()
    var tapSearchHistory = PublishRelay<String>()
    var saveSearchHistory = PublishRelay<String>()
  }
  
  struct Output {
    var dismiss = PublishRelay<Void>()
    var isSearchFilterShowing = PublishRelay<Bool>()
    var searchTerm = BehaviorRelay<String>(value: "")
    var currentContentType = BehaviorRelay<ContentType>(value: .searchHistory)
    var isTextFieldFocused = PublishRelay<Bool>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let searchHistoryManager = SearchHistoryManager()

  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()

    input.tapBackButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)

    input.tapFilterButton
      .subscribe(onNext: {
        output.isSearchFilterShowing.accept(true)
      })
      .disposed(by: disposeBag)

    input.tapClearButton
      .subscribe(onNext: {
        output.searchTerm.accept("")
        output.isTextFieldFocused.accept(true)
      })
      .disposed(by: disposeBag)

    input.editTextField
      .subscribe(onNext: { term in
        output.searchTerm.accept(term)
        output.currentContentType.accept(.searchHistory)
      })
      .disposed(by: disposeBag)

    input.search
      .subscribe(onNext: { _ in
        // Show search filter if all search filters are toggled off
        if UserDefaultsManager.searchWithTitle == false &&
            UserDefaultsManager.searchWithSinger == false {
          output.isSearchFilterShowing.accept(true)
          return
        }

        let term = output.searchTerm.value
        if term.isEmpty { return }
        
        output.currentContentType.accept(.searchResult(term))
        input.saveSearchHistory.accept(term)
      })
      .disposed(by: disposeBag)

    input.tapSearchHistory
      .subscribe(with: self, onNext: { strongSelf, term in
        output.isTextFieldFocused.accept(false)
        output.searchTerm.accept(term)
        strongSelf.input.search.accept(Void())
      })
      .disposed(by: disposeBag)

    input.saveSearchHistory
      .flatMap { [weak self] term in
        if let self = self {
          return self.searchHistoryManager.addData(searchKeyword: term)
        } else {
          return .empty()
        }
      }
      .subscribe()
      .disposed(by: disposeBag)

    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  public func addSearchHistory(_ keyword: String) {
    searchHistoryManager.addData(searchKeyword: keyword)
      .subscribe()
      .disposed(by: disposeBag)
  }
}

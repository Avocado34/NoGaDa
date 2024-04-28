//
//  SearchResultViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import Foundation

import RxSwift
import RxCocoa


final class SearchResultViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let search = PublishRelay<String>()
    let tapSongItem = PublishSubject<IndexPath>()
  }
  
  struct Output {
    let searchTerm = BehaviorRelay<String>(value: "")
    let searchResultSongs = BehaviorRelay<[Song]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let searchResultErrorState = PublishRelay<String>()
    let didSelectSongItem = PublishRelay<Song>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private var karaokeApiService = KaraokeApiService()
  
  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    input.search
      .map { term in
        output.searchTerm.accept(term)
        // Start loading
        output.searchResultErrorState.accept("")
        output.isLoading.accept(true)
        output.searchResultSongs.accept([])
      }
      .flatMap { [weak self] () -> Single<[Song]> in
        guard let self = self else { return .just([]) }
        if output.searchTerm.value.isEmpty {
          return .just([])
        }
        
        return self.karaokeApiService.fetchSong(
          titleOrSinger: output.searchTerm.value,
          brand: UserDefaultsManager.searchBrand)
      }
      .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { songs in
        output.isLoading.accept(false)
        
        if songs.isEmpty {
          output.searchResultErrorState.accept("검색 결과가 없습니다")
        } else {
          output.searchResultErrorState.accept("")
          output.searchResultSongs.accept(songs)
        }
      }, onError: { error in
        output.isLoading.accept(false)
        output.searchResultErrorState.accept("오류가 발생했습니다")
      })
      .disposed(by: disposeBag)
    
    input.tapSongItem
      .subscribe(onNext: { indexPath in
        let selectedSong = output.searchResultSongs.value[indexPath.row]
        output.didSelectSongItem.accept(selectedSong)
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  public var searchKeyword: String {
    return output.searchTerm.value
  }
}

//
//  ViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/18.
//

import Foundation

import RxSwift
import RxCocoa


final class MainViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = BehaviorRelay<Void>(value: Void())
    let viewDidAppear = BehaviorRelay<Void>(value: Void())
    let tapSearchBar = PublishSubject<Void>()
    let tapArchiveFolderView = PublishSubject<Void>()
    let tapSettingButton = PublishSubject<Void>()
    let tapNewUpdateSongItem = PublishSubject<IndexPath>()
    let changeSelectedKaraokeBrand = PublishRelay<KaraokeBrand>()
    let didSongAdded = PublishRelay<Void>()
    let didFileChanged = PublishRelay<Void>()
    let didFolderNameChanged = PublishRelay<Void>()
  }
  
  struct Output {
    let newUpdateSongs = BehaviorRelay<[Song]>(value: [])
    let selectedKaraokeBrand = BehaviorRelay<KaraokeBrand>(value: .tj)
    let isLoadingNewUpdateSongs = BehaviorRelay<Bool>(value: true)
    let newUpdateSongsErrorState = PublishRelay<String>()
    let amountOfSavedSongs = PublishRelay<String>()
    let showSearchVC = PublishRelay<Bool>()
    let showArchiveFolderVC = PublishRelay<Bool>()
    let showSettingVC = PublishRelay<Bool>()
    let showArchiveFolderFloadingView = PublishRelay<Song>()
    let showInitialAd = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let karaokeApiService = KaraokeApiService()
  private let songFolderManager = SongFolderManager()
  
  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    self.input = Input()
    let output = Output()
    
    Observable.merge(
      input.viewDidLoad.asObservable(),
      input.changeSelectedKaraokeBrand.asObservable()
        .map { brand in
          output.selectedKaraokeBrand.accept(brand)
        }.asObservable()
    )
    .map { _ in
      output.newUpdateSongs.accept([])
      output.isLoadingNewUpdateSongs.accept(true)
    }
    .flatMap { [weak self] () -> Single<[Song]> in
      guard let self = self else { return .never() }
      let selectedBrand = output.selectedKaraokeBrand.value
      return self.karaokeApiService.fetchUpdatedSong(brand: selectedBrand)
    }
    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    .observe(on: MainScheduler.instance)
    .subscribe(with: self, onNext: { strongSelf, songs  in
      if songs.isEmpty {
        output.newUpdateSongsErrorState.accept("업데이트 된 곡이 없습니다.")
      } else {
        output.newUpdateSongsErrorState.accept("")
        output.newUpdateSongs.accept(songs)
      }
      
      output.isLoadingNewUpdateSongs.accept(false)
    }, onError: { strongSelf, error in
      output.newUpdateSongsErrorState.accept("오류가 발생했습니다.")
      output.isLoadingNewUpdateSongs.accept(false)
    })
    .disposed(by: disposeBag)
    
    Observable.zip(
      input.viewDidLoad,
      input.viewDidAppear
    )
      .subscribe(onNext: { _ in
        output.showInitialAd.accept(Void())
      })
      .disposed(by: disposeBag)
    
    Observable.merge(
      input.viewDidAppear.map { _ in },
      input.didSongAdded.asObservable(),
      input.didFileChanged.asObservable()
    )
    .subscribe(onNext: { [weak self] _ in
      let amount = self?.songFolderManager.getAmountOfSongs() ?? 0
      let text = "총 \(amount)곡"
      output.amountOfSavedSongs.accept(text)
    })
    .disposed(by: disposeBag)
    
    input.tapSearchBar
      .subscribe(onNext: {
        output.showSearchVC.accept(true)
      })
      .disposed(by: disposeBag)
    
    input.tapArchiveFolderView
      .subscribe(onNext: {
        output.showArchiveFolderVC.accept(true)
      })
      .disposed(by: disposeBag)
    
    input.tapSettingButton
      .subscribe(onNext: {
        output.showSettingVC.accept(true)
      })
      .disposed(by: disposeBag)
    
    input.tapNewUpdateSongItem
      .subscribe(onNext: { indexPath in
        let selectedSong = output.newUpdateSongs.value[indexPath.row]
        output.showArchiveFolderFloadingView.accept(selectedSong)
      })
      .disposed(by: disposeBag)
    
    self.output = output
  }
}

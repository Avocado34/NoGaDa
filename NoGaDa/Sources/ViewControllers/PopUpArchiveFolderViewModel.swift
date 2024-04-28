//
//  PopUpSongFolderListViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/22.
//

import UIKit

import RxSwift
import RxCocoa


final class PopUpArchiveFolderViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let tapFolderItem = PublishSubject<IndexPath>()
    let tapAddFolderButton = PublishSubject<Void>()
    let didFolderAdded = PublishRelay<Void>()
    let tapExitButton = PublishSubject<Void>()
    let confirmAddSongButton = PublishRelay<(Song, ArchiveFolder)>()
    let tapRemoveFolderButton =  PublishRelay<IndexPath>()
  }
  
  struct Output {
    let folders = BehaviorRelay<[ArchiveFolder]>(value: [])
    let showingAddSongAlert = PublishRelay<(Song, ArchiveFolder)>()
    let showingAddFolderVC = PublishRelay<Void>()
    let dismiss = PublishRelay<Void>()
    let didSongAdded = PublishRelay<Void>()
    let playHapticFeedback = PublishRelay<UINotificationFeedbackGenerator.FeedbackType>()
    let showingAlreadyExistsAlert = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  public var selectedSong: Song
  private let folderManager = SongFolderManager()
  
  public var folders = BehaviorRelay<[ArchiveFolder]>(value: [])
  public var presentAlreadyExitstAlert = PublishRelay<Song>()
  public var playNotificationFeedback = PublishRelay<UINotificationFeedbackGenerator.FeedbackType>()
  public var didSongAdded = PublishRelay<Bool>()
  
  
  // MARK: - Initializers
  
  init() {
    fatalError("SelectedSong argument missing")
  }
  
  init(selectedSong: Song) {
    self.selectedSong = selectedSong
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    Observable.merge(
      input.viewDidLoad.asObservable(),
      input.didFolderAdded.asObservable()
    )
    .flatMap { [weak self] () -> Observable<[ArchiveFolder]> in
      guard let self = self else { return .empty() }
      return self.folderManager.fetchData()
    }
    .subscribe(onNext: { folder in
      output.folders.accept(folder)
    })
    .disposed(by: disposeBag)
    
    input.tapFolderItem
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        let targetFolder = output.folders.value[indexPath.row]
        output.showingAddSongAlert.accept((self.selectedSong, targetFolder))
      })
      .disposed(by: disposeBag)
    
    input.tapAddFolderButton
      .subscribe(onNext: {
        output.showingAddFolderVC.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapExitButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.confirmAddSongButton
      .flatMap { [weak self] (song, folder) -> Observable<Void> in
        guard let self = self else { return .empty() }
        return self.folderManager
          .addSong(songFolder: folder, song: song)
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.didSongAdded.accept(Void())
        output.playHapticFeedback.accept(.success)
      }, onError: { _ in
        output.showingAlreadyExistsAlert.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapRemoveFolderButton
      .subscribe(onNext: { indexPath in
        
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
}

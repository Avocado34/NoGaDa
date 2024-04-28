//
//  FolderViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import Foundation

import RxSwift
import RxCocoa


final class ArchiveSongViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishSubject<Void>()
    let viewWillDisappear = PublishSubject<Void>()
    let tapExitButton = PublishSubject<Void>()
    let tapAddSongButton = PublishSubject<Void>()
    let tapSongItem = PublishSubject<IndexPath>()
    let deleteSongItem = PublishRelay<IndexPath>()
    let songItemEdited = PublishRelay<Void>()
    let folderEmoji = BehaviorRelay<String>(value: "")
    let folderTitle = BehaviorRelay<String>(value: "")
  }
  
  struct Output {
    let currentFolder = PublishRelay<ArchiveFolder>()
    let archiveSongs = BehaviorRelay<[ArchiveSong]>(value: [])
    let dismiss = PublishRelay<Void>()
    let showingAddSongVC = PublishRelay<ArchiveFolder>()
    let showingSongOptionFloatingPanelView = PublishRelay<ArchiveSong>()
    let didFolderEdited = PublishRelay<Void>()
  }
  
  private(set) var disposeBag = DisposeBag()
  private(set) var input: Input!
  private(set) var output: Output!
  private var currentFolder: ArchiveFolder
  private let folderManager = SongFolderManager()
  
  public var folderTitle: String {
    return currentFolder.title
  }
  
  public var folderTitleEmoji: String {
    return currentFolder.titleEmoji
  }
  
  
  // MARK: - Initializers
  
  init() {
    fatalError("Missing argument 'currentFolder'")
  }
  
  init(currentFolder: ArchiveFolder) {
    self.currentFolder = currentFolder
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    self.input = Input()
    let output = Output()
    
    Observable.merge(
      input.viewDidLoad,
      input.songItemEdited.asObservable()
    )
    .flatMap { [weak self] () -> Observable<ArchiveFolder> in
      guard let self = self else { return .empty() }
      return self.folderManager.fetchData(self.currentFolder.id)
    }
    .subscribe(onNext: { folder in
      let songs = Array(folder.songs.reversed())
      output.archiveSongs.accept(songs)
    })
    .disposed(by: disposeBag)
    
    input.viewWillDisappear
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let isFolderEmojiUpdated = self.updateFolderEmojiIfNeeded()
        let isFolderTitleUpdated = self.updateFolderTitleIfNeeded()
        
        if (isFolderEmojiUpdated || isFolderTitleUpdated) {
          output.didFolderEdited.accept(Void())
        }
      })
      .disposed(by: disposeBag)
    
    input.tapExitButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapAddSongButton
      .subscribe(with: self, onNext: { strongSelf, _  in
        output.showingAddSongVC.accept(strongSelf.currentFolder)
      })
      .disposed(by: disposeBag)
    
    input.tapSongItem
      .subscribe(onNext: { indexPath in
        let selectedSong = output.archiveSongs.value[indexPath.row]
        output.showingSongOptionFloatingPanelView.accept(selectedSong)
      })
      .disposed(by: disposeBag)
    
    input.deleteSongItem
      .flatMap { indexPath -> Observable<[ArchiveSong]> in
        var songs = output.archiveSongs.value
        let targetSong = songs.remove(at: indexPath.row)
        let folderManager = SongFolderManager()
        return folderManager.deleteSong(song: targetSong)
          .andThen(.just(songs))
      }
      .subscribe(onNext: { editedSongs in
        output.archiveSongs.accept(editedSongs)
      })
      .disposed(by: disposeBag)
    
    self.output = output
  }
  
  
  // MARK: - Public
  
  public func updateFolderTitleIfNeeded() -> Bool {
    let newTitle = input.folderTitle.value
    if newTitle != currentFolder.title {
      folderManager.updateTitle(archiveFolder: currentFolder,newTitle: newTitle)
        .subscribe()
        .dispose()
      return true
    }
    
    return false
  }
  
  public func updateFolderEmojiIfNeeded() -> Bool {
    let newEmoji = input.folderEmoji.value
    if newEmoji != currentFolder.titleEmoji {
      folderManager.updateTitleEmoji(songFolder: currentFolder, newEmoji: newEmoji)
        .subscribe()
        .dispose()
      return true
    }
    
    return false
  }
}

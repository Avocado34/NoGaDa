//
//  PopUpSongOptionViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/14.
//

import Foundation

import RxSwift
import RxCocoa


final class PopUpSongOptionViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let tapOptionItem = PublishSubject<IndexPath>()
    let tapExitButton = PublishSubject<Void>()
    let deleteSong = PublishSubject<Void>()
  }
  
  struct Output {
    let dismiss = PublishRelay<Void>()
    let options = BehaviorRelay<[SongOption]>(value: [])
    let showingFolderFloatingPanelView = PublishRelay<ArchiveSong>()
    let showingDeleteSongAlert = PublishRelay<ArchiveSong>()
    let didSelectedSongItemEdited = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  public var selectedSong: ArchiveSong
  private let songFolderManager = SongFolderManager()

  private var songOptions: [SongOption] {
    let moveToOtherFolder = MoveToOtherFolder()
    let removeFromFolder = RemoveFromFolder()
    
    return [moveToOtherFolder, removeFromFolder]
  }
  
  public var sectionCount: Int {
    return 0
  }
  
  
  // MARK: - LifeCycle
  
  init() {
    fatalError("selectedSong has not been implemented")
  }
  
  init(selectedSong: ArchiveSong) {
    self.selectedSong = selectedSong
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    input.viewDidLoad
      .subscribe(with: self, onNext: { strongSelf, _  in
        output.options.accept(strongSelf.songOptions)
      })
      .disposed(by: disposeBag)
    
    input.tapExitButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapOptionItem
      .subscribe(with: self, onNext: { strongSelf, indexPath in
        switch indexPath.row {
        case 0:
          output.showingFolderFloatingPanelView
            .accept(strongSelf.selectedSong)
          break
        case 1:
          output.showingDeleteSongAlert
            .accept(strongSelf.selectedSong)
          break
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    input.deleteSong
      .flatMap { [weak self] () -> Observable<Void> in
        guard let self = self else { return .never() }
        return self.songFolderManager.deleteSong(song: self.selectedSong)
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.didSelectedSongItemEdited.accept(Void())
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  func numberOfRowsInSection(_ section: Int) -> Int {
    return songOptions.count
  }
  
  func optionAtIndex(_ indexPath: IndexPath) -> SongOption {
    return songOptions[indexPath.row]
  }
}

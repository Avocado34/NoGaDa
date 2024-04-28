//
//  AddSongViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/07.
//

import UIKit

import RxSwift
import RxCocoa


final class AddSongViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let songTitle = BehaviorRelay<String>(value: "")
    let singerName = BehaviorRelay<String>(value: "")
    let songNumber = BehaviorRelay<String>(value: "")
    let changeKaraokeBrand = PublishRelay<KaraokeBrand>()
    let tapBrandPickerButton = PublishSubject<Void>()
    let tapExitButton = PublishSubject<Void>()
    let tapConfirmButton = PublishSubject<Void>()
  }
  
  struct Output {
    let dismiss = PublishRelay<Void>()
    let showingBrandPickerView = PublishRelay<Void>()
    let confirmButtonActiveState = BehaviorRelay<Bool>(value: false)
    let karaokeBrand = BehaviorRelay<KaraokeBrand>(value: .tj)
    let succeedToAddSong = PublishRelay<Void>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private var targetFolderId: String?
  private var songFolderManager = SongFolderManager()
  
  public var numberOfComponents: Int {
    return 1
  }
  
  public var numberOfRowsInComponent: Int {
    return KaraokeBrand.allCases.count
  }
  
  
  // MARK: - LifeCycle
  
  init() {
    fatalError("You must give 'targetFolderId' to initialize")
  }
  
  init(targetFolderId: String) {
    self.targetFolderId = targetFolderId
    setupInputOutput()
  }
  
  
  // MARK: - Private
  
  private func setupInputOutput() {
    let input = Input()
    let output = Output()
    
    Observable.combineLatest(
      input.songTitle,
      input.singerName,
      resultSelector: { !$0.isEmpty && !$1.isEmpty }
    ).subscribe(onNext: { isAllTextFieldFilled in
      if isAllTextFieldFilled {
        output.confirmButtonActiveState.accept(true)
      } else {
        output.confirmButtonActiveState.accept(false)
      }
    })
    .disposed(by: disposeBag)
    
    input.changeKaraokeBrand
      .subscribe(onNext: { selectedBrand in
        output.karaokeBrand.accept(selectedBrand)
      })
      .disposed(by: disposeBag)
    
    input.tapBrandPickerButton
      .subscribe(onNext: {
        output.showingBrandPickerView.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapExitButton
      .subscribe(onNext: {
        output.succeedToAddSong.accept(Void())
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapConfirmButton
      .flatMap { [weak self] () -> Observable<ArchiveFolder> in
        guard let self = self,
              let targetFolderId = self.targetFolderId else {
          return .never()
        }
        
        return self.songFolderManager
          .fetchData(targetFolderId)
      }
      .flatMap { [weak self] folder -> Observable<Void> in
        guard let self = self else { return .never() }
        let song = Song(brand: output.karaokeBrand.value,
                        no: input.songNumber.value,
                        title: input.songTitle.value,
                        singer: input.singerName.value,
                        composer: "",
                        lyricist: "",
                        release: "")
        return self.songFolderManager
          .addSong(songFolder: folder, song: song)
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.succeedToAddSong.accept(Void())
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    self.input = input
    self.output = output
  }
  
  
  // MARK: - Public
  
  public func titleForRowAt(_ index: Int) -> String {
    return KaraokeBrand.allCases[index].localizedString
  }
}

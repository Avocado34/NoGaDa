//
//  ArchiveViewModel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/21.
//

import Foundation

import RxSwift
import RxCocoa


final class ArchiveFolderViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let tapExitButton = PublishSubject<Void>()
    let tapAddFolderButton = PublishSubject<Void>()
    let tapFolderItem = PublishSubject<IndexPath>()
    let deleteFolderItem = PublishRelay<IndexPath>()
    let confirmDeleteFolder = PublishRelay<ArchiveFolder>()
    let editFolder = PublishRelay<Void>()
  }
  
  struct Output {
    let folders = BehaviorRelay<[ArchiveFolder]>(value: [])
    let showingAddFolderVC = PublishRelay<Void>()
    let showingArchiveSongVC = PublishRelay<ArchiveFolder>()
    let showingDeleteFolderItemAlert = PublishRelay<ArchiveFolder>()
    let dismiss = PublishRelay<Void>()
    let didFolderEdited = PublishRelay<Void>()
  }
  
  private(set) var disposeBag = DisposeBag()
  private(set) var input: Input!
  private(set) var output: Output!
  private let folderManager = SongFolderManager()
  
  
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
      output.didFolderEdited.asObservable(),
      input.editFolder.asObservable()
    )
    .flatMap { (_) -> Observable<[ArchiveFolder]> in
      let folderManager = SongFolderManager()
      return folderManager.fetchData()
    }
    .subscribe(onNext: { folders in
      output.folders.accept(folders)
    })
    .disposed(by: disposeBag)
    
    input.tapExitButton
      .subscribe(onNext: {
        output.dismiss.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapAddFolderButton
      .subscribe(onNext: {
        output.showingAddFolderVC.accept(Void())
      })
      .disposed(by: disposeBag)
    
    input.tapFolderItem
      .subscribe(onNext: { indexPath in
        let selectedFolder = output.folders.value[indexPath.row]
        output.showingArchiveSongVC.accept(selectedFolder)
      })
      .disposed(by: disposeBag)
    
    input.deleteFolderItem
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { indexPath in
        let selectedFolder = output.folders.value[indexPath.row]
        output.showingDeleteFolderItemAlert.accept(selectedFolder)
      })
      .disposed(by: disposeBag)
    
    input.confirmDeleteFolder
      .flatMap { [weak self] targetFolder -> Observable<Void> in
        guard let self = self else { return .never() }
        return self.folderManager.deleteData(targetFolder)
          .andThen(.just(Void()))
      }
      .subscribe(onNext: {
        output.didFolderEdited.accept(Void())
      })
      .disposed(by: disposeBag)
    
    self.output = output
  }
}

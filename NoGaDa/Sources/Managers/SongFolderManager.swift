//
//  ArchiveFolderManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa


enum SongFolderManagerError: String, Error {
  case alreadyExists = "file already exists on Realm"
}

class SongFolderManager {
  
  private var disposeBag = DisposeBag()
  
  public func addData(title: String, titleEmoji: String) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        let archiveFolder = ArchiveFolder(title: title, titleEmoji: titleEmoji)
        
        try realmInstance.write {
          realmInstance.add(archiveFolder)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchData() -> Observable<[ArchiveFolder]> {
    return Observable.create { observer in
      do {
        let realmInstance = try Realm()
        let archiveFolders = realmInstance.objects(ArchiveFolder.self)
        observer.onNext(Array(archiveFolders))
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchData(_ id: String) -> Observable<ArchiveFolder> {
    return Observable.create { [weak self] observer in
      guard let self = self else { return Disposables.create() }
      
      self.fetchData()
        .subscribe(onNext: { songFolderList in
          songFolderList.forEach { songFolderRealm in
            if songFolderRealm.id == id {
              observer.onNext(songFolderRealm)
            }
          }
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        }).disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
  public func deleteData(_ archiveFolder: ArchiveFolder) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        
        try realmInstance.write {
          realmInstance.delete(archiveFolder.songs)
          realmInstance.delete(archiveFolder)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func updateTitle(archiveFolder: ArchiveFolder, newTitle: String) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        try realmInstance.write {
          archiveFolder.title = newTitle
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func updateTitleEmoji(songFolder: ArchiveFolder, newEmoji: String) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        
        try realmInstance.write {
          songFolder.titleEmoji = newEmoji
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func addSong(songFolder: ArchiveFolder, song: Song) -> Completable {
    return Completable.create { [weak self] observer in
      guard let self = self else { return Disposables.create() }
      
      do {
        let realmInsatnce = try Realm()
        
        let archiveSong = ArchiveSong(no: song.no,
                                      title: song.title,
                                      singer: song.singer,
                                      brand: song.brand.localizedString,
                                      composer: song.composer,
                                      lyricists: song.lyricist,
                                      releaseDate: song.release)
        
        if self.isSongExists(archiveFolder: songFolder, song: archiveSong) {
          observer(.error(SongFolderManagerError.alreadyExists))
          return Disposables.create()
        }
        
        try realmInsatnce.write {
          songFolder.songs.append(archiveSong)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func deleteSong(song: ArchiveSong) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        
        try realmInstance.write {
          realmInstance.delete(song)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  private func isSongExists(archiveFolder: ArchiveFolder, song: ArchiveSong) -> Bool {
    var isExists = false
    
    for archivedSong in archiveFolder.songs {
      if archivedSong.no == song.no && !archivedSong.no.isEmpty {
        isExists = true
      }
    }
    
    return isExists
  }
  
  public func getAmountOfSongs() -> Int {
    do {
      let realmInstance = try Realm()
      let archivedSongs = realmInstance.objects(ArchiveSong.self)
      return archivedSongs.count
    } catch {
      return 0
    }
  }
}

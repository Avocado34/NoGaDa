//
//  KaraokeManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/20.
//

import UIKit

import RxSwift
import RxCocoa

import Alamofire


final class KaraokeApiService {
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  
  
  // MARK: - Methods
  
  public func fetchUpdatedSong(brand: KaraokeBrand) -> Single<[Song]> {
    return Single.create { observer in
      guard let basePath = URL(string: KaraokeAPIPath.basePath.rawValue) else {
        observer(.failure(KaraokeAPIError.urlParsingError))
        return Disposables.create()
      }
      let fullPath = basePath.appendingPathComponent(brand.path)
      
      let request = AF.request(fullPath)
      request.responseDecodable(of: [Song].self) { response in
        if let error = response.error {
          observer(.failure(error))
          return
        }
        
        guard let value = response.value else {
          observer(.failure(KaraokeAPIError.httpRequestFailure))
          return
        }
        
        observer(.success(value))
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchSong(term: String, brand: KaraokeBrand) -> Single<[Song]> {
    return Single.create { observer in
      var term = term
      if term.isKorean() {
        term.removeAllEmptySpaces()
      }
      
      guard let basePath = URL(string: KaraokeAPIPath.basePath.rawValue) else {
        observer(.failure(KaraokeAPIError.urlParsingError))
        return Disposables.create()
      }
      
      let fullPath = basePath
        .appendingPathComponent(KaraokeAPIPath.song.rawValue)
        .appendingPathComponent("\(term)\(brand.path)")
      
      let request = AF.request(fullPath)
      request.responseDecodable(of: [Song].self) { response in
        if let error = response.error {
          observer(.failure(error))
        }
        
        guard let value = response.value else {
          observer(.failure(KaraokeAPIError.httpRequestFailure))
          return
        }
        
        observer(.success(value))
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchSong(singer: String, brand: KaraokeBrand) -> Single<[Song]> {
    return Single.create { observer in
      guard let basePath = URL(string: KaraokeAPIPath.basePath.rawValue) else {
        observer(.failure(KaraokeAPIError.urlParsingError))
        return Disposables.create()
      }
      
      let fullPath = basePath
        .appendingPathComponent(KaraokeAPIPath.singer.rawValue)
        .appendingPathComponent("\(singer)\(brand.path)")
      
      let request = AF.request(fullPath)
      request.responseDecodable(of: [Song].self) { response in
        if let error = response.error {
          observer(.failure(error))
          return
        }
        
        guard let value = response.value else {
          observer(.failure(KaraokeAPIError.httpRequestFailure))
          return
        }
        
        observer(.success(value))
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchSong(titleOrSinger: String, brand: KaraokeBrand) -> Single<[Song]> {
    let fetchWithTitle      = fetchSong(term: titleOrSinger, brand: brand).asObservable()
    let fetchWithSinger     = fetchSong(singer: titleOrSinger, brand: brand).asObservable()

    return Single.create { [weak self] observer in
      guard let self = self else { return Disposables.create() }

      if UserDefaultsManager.searchWithTitle == true &&
          UserDefaultsManager.searchWithSinger == true {
        // Search with singer & title
        Observable.combineLatest(
          fetchWithTitle,
          fetchWithSinger,
          resultSelector: { resultWithTitle, resultWithSinger in
          return Array(Set(resultWithTitle).union(Set(resultWithSinger))).sorted{ $0.title < $1.title }
        }).subscribe(onNext: { combinedSongResultList in
          observer(.success(combinedSongResultList))
        }, onError: { error in
          observer(.failure(error))
        }).disposed(by: self.disposeBag)
        
      }
      else if UserDefaultsManager.searchWithTitle == true &&
                UserDefaultsManager.searchWithSinger == false {
        // Search with title
        fetchWithTitle
          .subscribe(onNext: { songs in
            observer(.success(songs))
          }, onError: { error in
            observer(.failure(error))
          })
          .disposed(by: self.disposeBag)
        
      }
      else if UserDefaultsManager.searchWithTitle == false &&
                UserDefaultsManager.searchWithSinger == true {
        // Search with singer
        fetchWithSinger
          .subscribe(onNext: { songs in
            observer(.success(songs))
          }, onError: { error in
            observer(.failure(error))
          })
          .disposed(by: self.disposeBag)
      }

      return Disposables.create()
    }
  }
}

extension String {
  func urlEncode() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
  }
}

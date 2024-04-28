//
//  SearchHistoryManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/10.
//

import UIKit

import RealmSwift

import RxSwift
import RxCocoa


final class SearchHistoryManager {
  public func addData(searchKeyword: String) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        
        try realmInstance.write {
          let searchHistory = SearchHistory(keyword: searchKeyword)
          realmInstance.add(searchHistory, update: .modified)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func fetchData() -> Single<[SearchHistory]> {
    return Single.create { observer in
      do {
        let realmInstance = try Realm()
        var histories = Array(realmInstance.objects(SearchHistory.self))
        histories.sort { return $0.date > $1.date }
        
        observer(.success(histories))
      } catch {
        observer(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func deleteData(_ object: SearchHistory) -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        try realmInstance.write {
          realmInstance.delete(object)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func deleteAll() -> Completable {
    return Completable.create { observer in
      do {
        let realmInstance = try Realm()
        let searchHistoryList = Array(realmInstance.objects(SearchHistory.self))
        
        try realmInstance.write {
          realmInstance.delete(searchHistoryList)
        }
        
        observer(.completed)
      } catch {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
}

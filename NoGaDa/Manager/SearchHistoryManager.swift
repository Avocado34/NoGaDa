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

class SearchHistoryManager {
    
    func addData(searchKeyword: String) -> Completable {
        
        return Completable.create { completable in
            do {
                let realmInstance = try Realm()
                
                try realmInstance.write {
                    let searchHistory = SearchHistory(keyword: searchKeyword)
                    realmInstance.add(searchHistory, update: .modified)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchData() -> Observable<[SearchHistory]> {
        
        return Observable.create { observable in
            do {
                let realmInstance = try Realm()
                var searchHistoryList = Array(realmInstance.objects(SearchHistory.self))
                searchHistoryList.sort { return $0.date > $1.date }
                
                observable.onNext(searchHistoryList)
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteData(_ keyword: String) -> Completable {
        
        return Completable.create { completable in
            do {
                let realmInstance = try Realm()
                let searchHistoryList = realmInstance.objects(SearchHistory.self)
                
                try searchHistoryList.forEach { searchHistory in
                    if searchHistory.keyword == keyword {
                        try realmInstance.write {
                            realmInstance.delete(searchHistory)
                            completable(.completed)
                        }
                    }
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Completable {
        
        return Completable.create { completable in
            do {
                let realmInstance = try Realm()
                let searchHistoryList = Array(realmInstance.objects(SearchHistory.self))
                
                try realmInstance.write {
                    realmInstance.delete(searchHistoryList)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
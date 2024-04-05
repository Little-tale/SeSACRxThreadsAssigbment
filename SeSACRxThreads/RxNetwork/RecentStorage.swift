//
//  MoviewStorage.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

struct RecentModel: Equatable {
    var title: String
    var uuid = UUID()
    
    init(title: String) {
        self.title = title
      
    }
    init(model: RecentModel, updateTitle: String) {
        self = model
        title = updateTitle
    }
}

protocol MovieStorageType {
    
    // Create
    @discardableResult
    func createRecent(_ title: String) ->  Observable<RecentModel>
    
    // Read
    @discardableResult
    func loadRecentList() -> Observable<[RecentModel]>
}

class RecentStorage: MovieStorageType {
    
    private var dataList: [RecentModel] = [
        RecentModel(title:"테스트1"),
        RecentModel(title:"테스트2"),
        RecentModel(title:"테스트3")
    ]
    
    private lazy var store = BehaviorSubject<[RecentModel]>(value: dataList)
    
    @discardableResult
    func createRecent(_ title: String) -> Observable<RecentModel> {
        let model = RecentModel(title: title)
        
        dataList.append(model)
        
        store.onNext(dataList)
        
        return Observable.just(model)
    }
    
    @discardableResult
    func loadRecentList() -> Observable<[RecentModel]> {

        return store
    }
    
    
}

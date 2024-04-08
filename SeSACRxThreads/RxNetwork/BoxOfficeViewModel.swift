//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    private let recentStorage = RecentStorage()
   
    
    struct Input {
        let recentText: PublishSubject<String>
        let searchText: ControlProperty<String?>
        let searchButtonCliecked : ControlEvent<Void>
        
    }
    
    struct Output {
        let recentList: BehaviorRelay<[String]>
        let movieList: BehaviorRelay<[DailyBoxOfficeList]>
    }


    func transform(input: Input) -> Output {
        let recent = BehaviorRelay<[String]> (value: [])
        let movieList = BehaviorRelay<[DailyBoxOfficeList]> (value: [])
            
        recentStorage.loadRecentList()
            .map { $0.map { $0.title } }
            .bind { titles in
                recent.accept(titles)
            }.disposed(by: disposeBag)
        
        input.recentText
            .withUnretained(self)
            .bind { owner ,selectTitle in
                owner.recentStorage.createRecent(selectTitle)
            }.disposed(by: disposeBag)
        
        input.searchButtonCliecked
            .withLatestFrom(input.searchText.orEmpty)
            .map {
                guard let int = Int($0) else {
                    return "20170130"
                }
                return String(int)
            }
            .filter { $0.count == 8 }
            .catchAndReturn("20170130")
            .distinctUntilChanged()
            .flatMap { BoxOfficeNetwork.fetchBoxOfficeData(date: $0)}
            .catchAndReturn(.init(boxOfficeResult: .init(boxofficeType: "", showRange: "", dailyBoxOfficeList: [])))
            .map { $0.boxOfficeResult.dailyBoxOfficeList }
            .subscribe { result in
                movieList.accept(result)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }
            .disposed(by: disposeBag)

            
        //BoxOfficeNetwork.fetchBoxOfficeData(date: <#T##String#>)
        
        return Output(recentList: recent,
                      movieList: movieList)
    }
    
    
}





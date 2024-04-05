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
    
    /*
     let recent = Observable.just(["테스트", "테스트1", "테스트2"])
     
     let movie = Observable.just(["테스트10", "테스트11", "테스트12"])
     */
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





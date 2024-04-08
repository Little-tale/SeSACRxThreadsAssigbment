//
//  JokeSingleViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class JokeSingleViewModel: ViewModelType {
    
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool> // 그냥 넣어봄
        let addButtonTab: ControlEvent<Void>
    }
    
    struct Output {
        let dataItems: Driver<[Joke]>
        let outputCount: BehaviorRelay<String>
    }
    
    
    func proceccing(_ input: Input) -> Output {
        
        let dataItems = JokeStorage.shared.read()
            .asDriver(onErrorJustReturn: [])
        let behiverRe = BehaviorRelay(value: "")
        
        // network Area
        input
            .addButtonTab
            .debounce(.milliseconds(100),
                      scheduler: MainScheduler.instance)
            .debug()
            .flatMap {
                Network.shared.requestJoke()
                    .catchAndReturn(Joke(error: true, category: "", type: "", joke: "HI", id: 0, safe: true, lang: ""))
            }
            .bind { joke in
                JokeStorage.shared.insert(joke)
            }
            .disposed(by: disposeBag)
            
        
        dataItems
            .drive(with: self) { _, datas in
                behiverRe.accept("\(datas.count) 개")
            }.disposed(by: disposeBag)
        
        return .init(
            dataItems: dataItems,
            outputCount: behiverRe
        )
    }
    
}

/*
 Thread 1: Fatal error: Binding error: invalidURL
 
 let result = Network.shared.requestJoke()
 
 result.bind { joke in // 바인드로 할시 에러
     JokeStorage.shared.insert(joke)
 }.disposed(by: owner.disposeBag)
 */



/*
 .bind(with: self) { owner, _ in
     let result = Network.shared.requestJoke()
     result.subscribe { joke in // 바인드로 할시 에러
         JokeStorage.shared.insert(joke)
     }.disposed(by: owner.disposeBag)
 }.disposed(by: disposeBag)
 */

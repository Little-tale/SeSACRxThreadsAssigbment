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
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .debug()
            .bind(with: self) { owner, _ in
                let result = Network.shared.requestJoke()
                result.bind { joke in
                    JokeStorage.shared.insert(joke)
                }.disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
            
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

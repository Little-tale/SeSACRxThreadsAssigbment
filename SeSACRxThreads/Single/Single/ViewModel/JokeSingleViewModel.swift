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
    }
    
    
    func proceccing(_ input: Input) -> Output {
        
        let dataItems = JokeStorage.shared.read()
            .asDriver(onErrorJustReturn: [])
    
        
        return .init(
            dataItems: dataItems
        )
    }
    
}

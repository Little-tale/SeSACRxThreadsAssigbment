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
    
    // 데이터 저장소가 없음으로 일단여기서 하거나... 흠
    

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
    func proceccing(_ input: Input) -> Output {
        
        
        return .init()
    }
    
}

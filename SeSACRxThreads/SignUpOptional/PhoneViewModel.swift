//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import Foundation
import RxSwift
import RxCocoa


class PhoneViewModel: ViewModelType {
    
    struct Input {
        let phoneTextField: ControlProperty<String?>
        let nextButton: ControlEvent<Void>
    }
    let disposeBag: DisposeBag
    
    init(_ disposedBag: DisposeBag) {
        self.disposeBag = disposedBag
    }
    
    struct Output {
        // 벨리데이션 텍스트
        let validation: Driver<String>
        // testerText
        let testText: Driver<String>
        // 벨리데이션 Bool
        let validationBool: Driver<Bool>
    }
    
    func proceccing(_ input: Input) -> Output {
      
        // let firstEnter = Observable.just("010")
        // 오늘 startWith 를 찾아내고 해결한거 남기기
        let text = input
            .phoneTextField
            .orEmpty
            .startWith("010")
            .map {
                $0.filter { $0.isNumber }
            }.asDriver(onErrorJustReturn: "010")
        
        let validatBool = text
            .map { $0.count >= 10 }
            .asDriver()
        
        let testText = validatBool
            .map { $0 ? "" : "글자를 입력해주세요" }
            .asDriver()
        
        
        return Output(
            validation: text,
            testText: testText,
            validationBool: validatBool
        )
    }
}
// 오늘 share 에 대해서 더욱 연구하고 알아보기

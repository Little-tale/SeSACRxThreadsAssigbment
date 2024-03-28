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
    
    let firstNumber = Observable.just("010")
    
    
    struct Input {
        let phoneTextField: ControlProperty<String?>
        let nextButton: ControlEvent<Void>
    }
    let disposedBag: DisposeBag
    
    init(_ disposedBag: DisposeBag) {
        self.disposedBag = disposedBag
    }
    
    struct Output {
        let validfirsText: Observable<String>
        // 벨리데이션 텍스트
        let validation: Observable<String>
        // testerText
        let testText: Observable<String>
        // 벨리데이션 Bool
        let validationBool: Observable<Bool>
    }
    
    func proceccing(_ input: Input) -> Output {
      
//        let text = input.phoneTextField.orEmpty.compactMap { String(Int($0)) }
        
        let text = input.phoneTextField.orEmpty.map { $0.filter { $0.isNumber } }
        
        let validatBool = text.map { $0.count >= 10 }
            .share(replay: 1)
        
        let testText = validatBool.map { $0 ? "" : "글자를 입력해주세요" }
        
        return Output(
            validfirsText: firstNumber,
            validation: text,
            testText: testText,
            validationBool: validatBool
        )
    }
}

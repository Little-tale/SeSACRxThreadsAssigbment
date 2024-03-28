//
//  passwordViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func proceccing(_ input: Input) -> Output
    
}

class PasswordViewModel: ViewModelType {

    
    struct Input {
        let passwordTextField: ControlProperty<String?>
        // let nextButton: ControlEvent<Void>
    }
    
    struct Output {
        let vaildTrigger: Observable<Bool>
    }
    
    func proceccing(_ input: Input) -> Output {
        let vaild = input.passwordTextField.orEmpty.map { $0.count > 8 }
    
        return Output(vaildTrigger: vaild)
    }
    
}

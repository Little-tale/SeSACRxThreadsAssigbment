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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let passwordTextField: ControlProperty<String?>
        // let nextButton: ControlEvent<Void>
    }
    
    struct Output {
        let vaildTrigger: Observable<Bool>
    }
    
    func proceccing(_ input: Input) -> Output {
        let vaild = input.passwordTextField
            .orEmpty
            .map(validCheckPassword)
    
        return Output(vaildTrigger: vaild)
    }
    
    private func validCheckPassword(_ text: String) -> Bool {
        if text.isEmpty {
            return !text.isEmpty
        }
        
        // email
        //let regex =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // password
        let regex = "[a-zA-Z0-9]+$"
        
        if text.count < 8 {
            return false
        }
        return matchesPattern(text, pattern: regex)
    }
    
}

extension ViewModelType {
    func matchesPattern(_ string: String, pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            
            return regex.firstMatch(in: string, range: range) != nil
        } catch {
            print(error)
            return false
        }
    }
}

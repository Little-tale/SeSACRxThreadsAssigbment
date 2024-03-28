//
//  SignupViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    private let cantWords = ["덴","브렌","휴","젝"]

    struct Input {
        let emailTextField: ControlProperty<String?>
    }
    
    struct Output {
        let valitation: Observable<(isValid: Bool, message: String)>
    }
    
    func proceccing(_ input: Input) -> Output {
        // 1. @ 있을까?
        // 2. 10 글자 이상일까?
        // 3. 둘다 맞다면 true로 주자!
        let vaild = input.emailTextField.orEmpty
            .map { [weak self] email -> (isValid: Bool, message: String) in
                guard let weakSelf = self else { return (false, "") }
                
                if let cant = weakSelf.cantWords.first(
                    where: { email.contains($0) }
                ) {
                    return (false, "이메일형식이 이상해요! \(cant)")
                }
                if email.contains("@") && email.count > 10 {
                    return(true, "")
                } else {
                    return(false, "이메일 형식엔 @가 있어야 겠죠?")
                }
            }
        
        return Output(valitation: vaild)
    }
    
}

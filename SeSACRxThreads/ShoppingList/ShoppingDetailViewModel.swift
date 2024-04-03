//
//  ShoppingDetailViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingDetailViewModel: ViewModelType {
    
    
    weak var changedModelDelegate: ShoppingUserModelChangedDelegate?
    
    var disposeBag = DisposeBag()
    
    private var willModifyModel = UserModel(
        title: "",
        selectedBool: false
    )
    
    struct Input {
        let checkButtonControl: ControlEvent<Void>
        let starButtonControl: ControlEvent<Void>
        let titleTextFiedl: ControlProperty<String?>
        let SaveButton: ControlEvent<Void>
        let model: UserModel
    }
    
    struct Output {
        let checkButtonState: BehaviorRelay<Bool>
        let starButtonControl: BehaviorRelay<Bool>
        let titleText: BehaviorRelay<String>
    }
    
    func proceccing(_ input: Input) -> Output {
        
        willModifyModel = input.model
        
        let checkButton = BehaviorRelay(value: input.model.selectedBool)
        
        let starButton = BehaviorRelay(value: input.model.starBool)
        
        let titleText = BehaviorRelay(value: input.model.title)
        
        input
            .checkButtonControl
            .debug()
            .bind(with: self) { owner, _ in
                let select = owner.willModifyModel.selectedBool
                owner.willModifyModel.selectedBool = !select
                dump(owner.willModifyModel)
        }.disposed(by: disposeBag)
        
        input.starButtonControl
            .bind(with: self) { owner , _ in
                let select = owner.willModifyModel.starBool
                owner.willModifyModel.starBool = !select
                dump(owner.willModifyModel)
            }.disposed(by: disposeBag)
        
        input.titleTextFiedl
            .orEmpty
            .filter({ !$0.isEmpty })
            .bind(with: self) { owner, string in
                owner.willModifyModel.title = string
            }.disposed(by: disposeBag)
        
        
        input.SaveButton.bind(with: self) { owner, _ in
            owner.changedModelDelegate?.modelChaged(owner.willModifyModel)
        }.disposed(by: disposeBag)
        
        return .init(
            checkButtonState: checkButton,
            starButtonControl: starButton,
            titleText: titleText
        )
    }
    
}

//
//  ShoppingTableCellViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/2/24.
//

import Foundation
import RxCocoa
import RxSwift

class ShoppingTableCellViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let modelUpdatted = PublishSubject<UserModel> ()
    
    struct Input {
        let inputcheckButton: ControlEvent<Void>
        let inputStarButton: ControlEvent<Void>
        let model: UserModel
    }
    
    
    struct Output {
        let ObserVelModel: Observable<UserModel>
    }
    
    func proceccing(_ input: Input) -> Output {
        let model = BehaviorSubject(value: input.model)
        
        input.inputcheckButton
            .withLatestFrom(model)
            .bind(with: self) { owner, userModel in
                var newModel = userModel
                newModel.selectedBool.toggle()
                model.onNext(newModel)
                owner.modelUpdatted.onNext(newModel)
            }.disposed(by: disposeBag)
        
        input.inputStarButton
            .withLatestFrom(model)
            .bind(with: self) { owner, userModel in
                var newModel = userModel
                newModel.starBool.toggle()
                model.onNext(newModel)
                owner.modelUpdatted.onNext(newModel)
            }.disposed(by: disposeBag)

        return Output(ObserVelModel: model)
    }
    
}


//private let starButton = BehaviorRelay(value: false)
//private let checkButton = BehaviorRelay(value: false)
//private let title =  BehaviorRelay(value: "")
//    init(_ disposeBag: DisposeBag) {
//        self.disposeBag = disposeBag
//    }
    
/*
 회고
 input.inputcheckButton.bind(with: self) { owner, _ in
    model.selectedBool.toggle()
 }.disposed(by: disposeBag)

input.inputcheckButton.bind(with: self) { owner, _ in
    model.starBool.toggle()
}.disposed(by: disposeBag)

let observer = Observable(model)
return Output()
 */

//
//  ShoppingTableCellViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/2/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol ShoppingUserModelChangedDelegate: AnyObject {
    func modelChaged(_ model : UserModel)
}

class ShoppingTableCellViewModel {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: ShoppingUserModelChangedDelegate?
    // let userModel: BehaviorSubject<UserModel>
    

    struct Input {
        let checkButtonTap: ControlEvent<Void>
        let starButtonTap: ControlEvent<Void>
        let userModel: UserModel
    }
    struct Output {
        let checkButtonState: BehaviorRelay<Bool>
        let starButtonState: BehaviorRelay<Bool>
    }
    
    func proceccing(_ input: Input) -> Output {
        
        
        let userObser = BehaviorSubject(value: input.userModel)
        
        
        
        // 체크 버튼 탭 처리
        input.checkButtonTap
            .withLatestFrom(userObser)
            .withUnretained(self)
            .subscribe(onNext: { owner, model in
                var newModel = model
                newModel.selectedBool.toggle()
                userObser.onNext(newModel)
                owner.delegate?.modelChaged(newModel)
            }).disposed(by: disposeBag)
        
        // 별 버튼 탭 처리
        input.starButtonTap
            .withLatestFrom(userObser)
            .withUnretained(self)
            .subscribe(onNext: { owner, model in
                var newModel = model
                newModel.starBool.toggle()
                userObser.onNext(newModel)
                owner.delegate?.modelChaged(newModel)
            }).disposed(by: disposeBag)
        
        return Output(
            checkButtonState: BehaviorRelay(
                value: input.userModel.selectedBool
            ),
            starButtonState: BehaviorRelay(
                value: input.userModel.starBool
            )
        )
        
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


/*
 let modelUpdatted = PublishSubject<UserModel>()
 
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
 */

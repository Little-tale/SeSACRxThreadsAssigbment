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
    
    private let userModel: BehaviorSubject<UserModel>
    
    struct Input {
        let checkButtonTap: ControlEvent<Void>
        let starButtonTap: ControlEvent<Void>
    
    }
    
    struct Output {
        let modelUpdated: Observable<UserModel>
    }
    
    init(userModel: UserModel) {
        self.userModel = BehaviorSubject(value: userModel)
    }
    
    func proceccing(_ input: Input) -> Output {
        // 체크 버튼 탭 처리
        input.checkButtonTap
            .withLatestFrom(userModel)
            .subscribe(onNext: { [weak self] model in
                var newModel = model
                newModel.selectedBool.toggle()
                self?.userModel.onNext(newModel)
            }).disposed(by: disposeBag)
        
        // 별 버튼 탭 처리
        input.starButtonTap
            .withLatestFrom(userModel)
            .subscribe(onNext: { [weak self] model in
                var newModel = model
                newModel.starBool.toggle()
                self?.userModel.onNext(newModel)
            }).disposed(by: disposeBag)
        
        return Output(modelUpdated: userModel.asObservable())
        
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

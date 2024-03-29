//
//  SampleViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/30/24.
//

import Foundation
import RxSwift
import RxCocoa

class SampleViewModel: ViewModelType {
   
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    let disposeBag: DisposeBag
    
    let dummyData = BehaviorRelay(value: [
        "Hue","Jack","Bren","Den","KING"
    ])
    
    struct Input {
        let textControl: ControlProperty<String?>
        let tapControl: ControlEvent<Void>
        let itemseleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let outputValues: BehaviorRelay<[String]>
    }
    func proceccing(_ input: Input) -> Output {
    
        input.tapControl.withLatestFrom(input.textControl.orEmpty)
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, string in
                var current = owner.dummyData.value
                current.append(string)
                owner.dummyData.accept(current)
            }.disposed(by: disposeBag)
       
        input.itemseleted.bind(with: self) { owner, indexPath in
            var current = owner.dummyData.value
            current.remove(at: indexPath.row)
            owner.dummyData.accept(current)
        }.disposed(by: disposeBag)
        
       
        return Output(outputValues: dummyData)
    }
    
}


/* // 콤바인 결과
 func proceccing(_ input: Input) -> Output {
     
     let insertText = input.textControl
         .orEmpty
         .filter { !$0.isEmpty }
         .scan(dummyData.value) { current, new in
             return current + [new]
         }
     
     let combine = Observable.combineLatest(insertText, input.tapControl)
     
     combine.bind(with: self) { owner, values in
         owner.dummyData.accept(values.0)
     }.disposed(by: disposeBag)
     
     return Output(outputValues: dummyData)
 }
 */

/* //MARK: 이것도 회고
 func proceccing(_ input: Input) -> Output {
 
     let combine = Observable.combineLatest(input.textControl.orEmpty, input.tapControl) {[weak self] addString, event in
         guard let weakSelf = self else { return ["Error"] }
         
         var old = weakSelf.dummyData.value
         old.append(addString)
         return old
     }
     
     combine.bind(with: self) { owner, values in
         owner.dummyData.accept(values)
     }.disposed(by: disposeBag)
     
     return Output(outputValues: dummyData)
 }
 */
